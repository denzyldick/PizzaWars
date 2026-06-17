use bevy::prelude::*;
use super::{GravityAffected, Grounded, IsGameEntity, Platform, Velocity, GROUND_Y, WORLD_HEIGHT};

const PLATFORM_WIDTH: f32 = 97.0;
const PLATFORM_HEIGHT: f32 = 16.0;

#[derive(Component)]
pub struct MovingPlatform {
    pub direction: f32,
    pub speed: f32,
}

pub fn spawn_platforms(commands: &mut Commands, asset_server: &Res<AssetServer>) {
    let texture = asset_server.load("images/platform.png");
    let dark_texture = asset_server.load("images/platformDark.png");

    let static_positions = [
        (1.0, 99.0),
        (100.0, 100.0),
        (211.0, 124.0),
        (373.0, 127.0),
        (559.0, 74.0),
        (312.0, 276.0),
    ];

    for &(x, y) in &static_positions {
        commands.spawn((
            Sprite::from_image(texture.clone()),
            Transform::from_xyz(x, y, 0.0),
            Platform,
            IsGameEntity,
        ));
    }

    for i in 0..7 {
        commands.spawn((
            Sprite::from_image(texture.clone()),
            Transform::from_xyz(i as f32 * PLATFORM_WIDTH, GROUND_Y, 0.0),
            Platform,
            IsGameEntity,
        ));
    }

    commands.spawn((
        Sprite::from_image(dark_texture.clone()),
        Transform::from_xyz(515.0, 224.0, 0.0),
        Platform,
        MovingPlatform {
            direction: 1.0,
            speed: 100.0,
        },
        IsGameEntity,
    ));

    commands.spawn((
        Sprite::from_image(dark_texture),
        Transform::from_xyz(103.0, 337.0, 0.0),
        Platform,
        MovingPlatform {
            direction: 1.0,
            speed: 100.0,
        },
        IsGameEntity,
    ));
}

pub fn collision_system(
    time: Res<Time>,
    mut platforms: Query<(&mut Transform, Option<&mut MovingPlatform>), With<Platform>>,
    mut players: Query<(&mut Velocity, &mut Transform, &mut Grounded), (With<GravityAffected>, Without<Platform>)>,
) {
    for (mut platform_transform, moving) in platforms.iter_mut() {
        if let Some(mut mp) = moving {
            platform_transform.translation.y += mp.direction * mp.speed * time.delta_secs();
            if platform_transform.translation.y <= 0.0 {
                platform_transform.translation.y = WORLD_HEIGHT;
            }
        }

        for (mut velocity, mut player_transform, mut grounded) in players.iter_mut() {
            if !aabb_collision(&player_transform, &platform_transform) {
                continue;
            }
            let player_bottom = player_transform.translation.y;
            let platform_top = platform_transform.translation.y + PLATFORM_HEIGHT / 2.0;

            if velocity.0.y <= 0.0 && (player_bottom - platform_top).abs() < 20.0 {
                player_transform.translation.y = platform_top;
                velocity.0.y = 0.0;
                grounded.0 = true;
            }
        }
    }
}

fn aabb_collision(a: &Transform, b: &Transform) -> bool {
    let a_half = Vec2::new(20.0, 30.0);
    let b_half = Vec2::new(PLATFORM_WIDTH / 2.0, PLATFORM_HEIGHT / 2.0);

    let a_pos = a.translation.truncate();
    let b_pos = b.translation.truncate();

    let a_min = a_pos - a_half;
    let a_max = a_pos + a_half;
    let b_min = b_pos - b_half;
    let b_max = b_pos + b_half;

    a_min.x < b_max.x
        && a_max.x > b_min.x
        && a_min.y < b_max.y
        && a_max.y > b_min.y
}
