use bevy::prelude::*;
use crate::{GameState, WORLD_HEIGHT, WORLD_WIDTH};

pub struct GameOverPlugin;

impl Plugin for GameOverPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(OnEnter(GameState::GameOver), spawn_game_over)
            .add_systems(
                Update,
                game_over_input.run_if(in_state(GameState::GameOver)),
            )
            .add_systems(OnExit(GameState::GameOver), despawn_game_over);
    }
}

#[derive(Component)]
struct GameOverEntity;

fn spawn_game_over(mut commands: Commands, asset_server: Res<AssetServer>) {
    commands.spawn((
        Sprite::from_image(asset_server.load("images/greenwins.png")),
        Transform::from_xyz(WORLD_WIDTH / 2.0, WORLD_HEIGHT / 2.0, 0.0),
        GameOverEntity,
    ));
}

fn game_over_input(
    keyboard: Res<ButtonInput<KeyCode>>,
    mouse: Res<ButtonInput<MouseButton>>,
    mut next_state: ResMut<NextState<GameState>>,
) {
    if keyboard.just_pressed(KeyCode::Space) || mouse.just_pressed(MouseButton::Left) {
        next_state.set(GameState::Menu);
    }
}

fn despawn_game_over(mut commands: Commands, entities: Query<Entity, With<GameOverEntity>>) {
    for entity in entities.iter() {
        commands.entity(entity).despawn();
    }
}
