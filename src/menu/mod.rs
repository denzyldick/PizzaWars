use bevy::prelude::*;
use crate::{GameState, WORLD_HEIGHT, WORLD_WIDTH};

pub struct MenuPlugin;

impl Plugin for MenuPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(OnEnter(GameState::Menu), spawn_menu)
            .add_systems(Update, menu_input.run_if(in_state(GameState::Menu)))
            .add_systems(OnExit(GameState::Menu), despawn_menu);
    }
}

#[derive(Component)]
struct MenuEntity;

#[derive(Component)]
struct StartButton;

fn spawn_menu(mut commands: Commands, asset_server: Res<AssetServer>) {
    commands.spawn((
        Sprite::from_image(asset_server.load("images/MenuBackground.png")),
        Transform::from_xyz(WORLD_WIDTH / 2.0, WORLD_HEIGHT / 2.0, 0.0),
        MenuEntity,
    ));

    commands.spawn((
        Sprite::from_image(asset_server.load("images/logo.png")),
        Transform::from_xyz(900.0, 100.0, 1.0),
        MenuEntity,
    ));

    commands.spawn((
        Sprite::from_image(asset_server.load("images/startButton.png")),
        Transform::from_xyz(0.0, 200.0, 1.0),
        StartButton,
        MenuEntity,
    ));

    commands.spawn((
        Sprite::from_image(asset_server.load("images/InstructionsButton.png")),
        Transform::from_xyz(900.0, 300.0, 1.0),
        MenuEntity,
    ));
}

fn menu_input(
    mouse: Res<ButtonInput<MouseButton>>,
    windows: Query<&Window>,
    camera: Query<(&Camera, &GlobalTransform)>,
    start_buttons: Query<&GlobalTransform, With<StartButton>>,
    mut next_state: ResMut<NextState<GameState>>,
) {
    if !mouse.just_pressed(MouseButton::Left) {
        return;
    }

    let window = windows.single();
    let Some(cursor_pos) = window.cursor_position() else {
        return;
    };

    let (camera, camera_transform) = camera.single();
    let Ok(world_pos) = camera.viewport_to_world_2d(camera_transform, cursor_pos) else {
        return;
    };

    for transform in start_buttons.iter() {
        let half = Vec2::splat(40.0);
        let pos = transform.translation().truncate();
        if (world_pos - pos).abs().cmplt(half).all() {
            next_state.set(GameState::Playing);
            return;
        }
    }
}

fn despawn_menu(mut commands: Commands, entities: Query<Entity, With<MenuEntity>>) {
    for entity in entities.iter() {
        commands.entity(entity).despawn();
    }
}
