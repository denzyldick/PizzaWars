use bevy::prelude::*;
use super::{Owner, Player, Velocity};

pub fn movement_system(
    time: Res<Time>,
    mut pizzas: Query<(&mut Transform, &Velocity), With<super::PizzaSlice>>,
) {
    for (mut transform, velocity) in pizzas.iter_mut() {
        transform.translation.x += velocity.0.x * time.delta_secs();
        transform.translation.y += velocity.0.y * time.delta_secs();
        transform.rotation = Quat::from_rotation_z(
            transform.rotation.to_euler(EulerRot::XYZ).2 + 3.0 * time.delta_secs(),
        );
    }
}

pub fn hit_system(
    mut commands: Commands,
    pizzas: Query<(Entity, &Transform, &Owner), With<super::PizzaSlice>>,
    mut players: Query<(&mut Player, &Transform)>,
) {
    for (pizza_entity, pizza_transform, _owner) in pizzas.iter() {
        for (mut player, player_transform) in players.iter_mut() {
            if player.lives == 0 {
                continue;
            }

            let distance = pizza_transform
                .translation
                .truncate()
                .distance(player_transform.translation.truncate());

            if distance < 30.0 {
                player.lives = player.lives.saturating_sub(1);
                commands.entity(pizza_entity).despawn();
                break;
            }
        }
    }
}
