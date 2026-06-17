use bevy::prelude::*;

pub mod pizza;
pub mod platform;
pub mod player;

pub const GRAVITY: f32 = -980.0;
pub const GROUND_Y: f32 = 500.0;
pub const PLAYER_SPEED: f32 = 100.0;
pub const JUMP_VELOCITY: f32 = 350.0;
pub const PIZZA_SPEED: f32 = 200.0;
pub const MAX_LIVES: u32 = 3;
pub const WORLD_WIDTH: f32 = 600.0;
pub const WORLD_HEIGHT: f32 = 400.0;

#[derive(Component)]
pub struct Velocity(pub Vec2);

#[derive(Component)]
pub struct GravityAffected;

#[derive(Component)]
pub struct Grounded(pub bool);

#[derive(Component)]
pub struct Player {
    pub color: PlayerColor,
    pub lives: u32,
    pub facing: Facing,
}

#[derive(Component)]
pub struct PlayerSpawn(pub Vec2);

#[derive(Clone, PartialEq)]
pub enum PlayerColor {
    Red,
    Green,
}

pub enum Facing {
    Left,
    Right,
}

#[derive(Component)]
pub struct Heart;

#[derive(Component)]
pub struct PizzaSlice;

#[derive(Component)]
pub struct Platform;

#[derive(Component)]
pub struct Owner(pub Entity);

#[derive(Component)]
pub struct IsGameEntity;

pub struct GamePlugin;

impl Plugin for GamePlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(OnEnter(super::GameState::Playing), spawn_game)
            .add_systems(
                Update,
                (
                    player::movement_system,
                    player::jump_system,
                    player::shoot_system,
                    pizza::movement_system,
                    pizza::hit_system,
                    platform::collision_system,
                    gravity_system,
                    cleanup_pizza_offscreen,
                    game_over_check_system,
                )
                    .run_if(in_state(super::GameState::Playing)),
            )
            .add_systems(OnExit(super::GameState::Playing), despawn_game);
    }
}

fn gravity_system(mut query: Query<(&mut Velocity, &GravityAffected)>) {
    for (mut velocity, _) in query.iter_mut() {
        velocity.0.y += GRAVITY * 0.016;
    }
}

fn spawn_game(mut commands: Commands, asset_server: Res<AssetServer>) {
    commands.spawn((
        Sprite::from_image(asset_server.load("images/gameBackground.png")),
        Transform::from_xyz(WORLD_WIDTH / 2.0, WORLD_HEIGHT / 2.0, 0.0),
        IsGameEntity,
    ));

    player::spawn_player(
        &mut commands,
        &asset_server,
        PlayerColor::Red,
        Vec2::new(100.0, 40.0),
        Vec2::new(8.0, 12.0),
    );
    player::spawn_player(
        &mut commands,
        &asset_server,
        PlayerColor::Green,
        Vec2::new(460.0, 40.0),
        Vec2::new(510.0, 12.0),
    );

    platform::spawn_platforms(&mut commands, &asset_server);
}

fn despawn_game(mut commands: Commands, entities: Query<Entity, With<IsGameEntity>>) {
    for entity in entities.iter() {
        commands.entity(entity).despawn();
    }
}

fn cleanup_pizza_offscreen(
    mut commands: Commands,
    pizzas: Query<(Entity, &Transform), With<PizzaSlice>>,
) {
    for (entity, transform) in pizzas.iter() {
        if transform.translation.x < -50.0 || transform.translation.x > WORLD_WIDTH + 50.0 {
            commands.entity(entity).despawn();
        }
    }
}

fn game_over_check_system(
    players: Query<&Player>,
    mut next_state: ResMut<NextState<super::GameState>>,
) {
    for player in players.iter() {
        if player.lives == 0 {
            next_state.set(super::GameState::GameOver);
            return;
        }
    }
}
