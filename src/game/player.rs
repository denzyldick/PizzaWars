use bevy::prelude::*;
use super::{
    Facing, GravityAffected, Grounded, Heart, IsGameEntity, MAX_LIVES, Player, PlayerColor,
    PlayerSpawn, JUMP_VELOCITY, PLAYER_SPEED, Velocity,
};

pub fn spawn_player(
    commands: &mut Commands,
    asset_server: &Res<AssetServer>,
    color: PlayerColor,
    position: Vec2,
    spawn: Vec2,
) {
    let idle_path = match color {
        PlayerColor::Red => "images/red/playerIdle0R.png",
        PlayerColor::Green => "images/green/playerIdle0R.png",
    };

    let player_entity = commands
        .spawn((
            Sprite::from_image(asset_server.load(idle_path)),
            Transform::from_xyz(position.x, position.y, 1.0),
            Player {
                color: color.clone(),
                lives: MAX_LIVES,
                facing: Facing::Right,
            },
            PlayerSpawn(spawn),
            Velocity(Vec2::ZERO),
            GravityAffected,
            Grounded(false),
            IsGameEntity,
        ))
        .id();

    for i in 0..MAX_LIVES {
        commands.spawn((
            Sprite::from_image(asset_server.load("images/heart.png")),
            Transform::from_xyz(spawn.x + i as f32 * 22.0, spawn.y, 2.0),
            Heart,
            IsGameEntity,
        ));
    }
}

pub fn movement_system(
    keyboard: Res<ButtonInput<KeyCode>>,
    mut players: Query<(&mut Velocity, &mut Player)>,
) {
    for (mut velocity, mut player) in players.iter_mut() {
        let is_red = player.color == PlayerColor::Red;

        let (left, right) = if is_red {
            (KeyCode::KeyA, KeyCode::KeyD)
        } else {
            (KeyCode::ArrowLeft, KeyCode::ArrowRight)
        };

        velocity.0.x = 0.0;

        if keyboard.pressed(left) {
            velocity.0.x = -PLAYER_SPEED;
            player.facing = Facing::Left;
        } else if keyboard.pressed(right) {
            velocity.0.x = PLAYER_SPEED;
            player.facing = Facing::Right;
        }
    }
}

pub fn jump_system(
    keyboard: Res<ButtonInput<KeyCode>>,
    mut players: Query<(&mut Velocity, &Player, &Grounded)>,
) {
    for (mut velocity, player, grounded) in players.iter_mut() {
        if !grounded.0 {
            continue;
        }

        let jump_key = if player.color == PlayerColor::Red {
            KeyCode::KeyW
        } else {
            KeyCode::ArrowUp
        };

        if keyboard.just_pressed(jump_key) {
            velocity.0.y = JUMP_VELOCITY;
        }
    }
}

pub fn shoot_system(
    mut commands: Commands,
    keyboard: Res<ButtonInput<KeyCode>>,
    asset_server: Res<AssetServer>,
    players: Query<(Entity, &Transform, &Player)>,
) {
    for (entity, transform, player) in players.iter() {
        let shoot_key = if player.color == PlayerColor::Red {
            KeyCode::KeyS
        } else {
            KeyCode::ArrowDown
        };

        if keyboard.just_pressed(shoot_key) {
            let direction_x = match player.facing {
                Facing::Right => super::PIZZA_SPEED,
                Facing::Left => -super::PIZZA_SPEED,
            };

            commands.spawn((
                Sprite::from_image(asset_server.load("images/pizzaslice-projectile.png")),
                Transform::from_xyz(transform.translation.x, transform.translation.y, 1.0),
                super::PizzaSlice,
                super::Owner(entity),
                Velocity(Vec2::new(direction_x, 0.0)),
                IsGameEntity,
            ));
        }
    }
}
