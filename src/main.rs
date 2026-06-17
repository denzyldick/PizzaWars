use bevy::prelude::*;

mod game;
mod game_over;
mod menu;

pub const WORLD_WIDTH: f32 = 600.0;
pub const WORLD_HEIGHT: f32 = 400.0;

#[derive(States, Clone, Eq, PartialEq, Debug, Hash, Default)]
enum GameState {
    #[default]
    Menu,
    Playing,
    GameOver,
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins.set(WindowPlugin {
            primary_window: Some(Window {
                title: "Pizza Wars 2.0".into(),
                resolution: (WORLD_WIDTH, WORLD_HEIGHT).into(),
                resizable: false,
                ..default()
            }),
            ..default()
        }))
        .init_state::<GameState>()
        .add_systems(Startup, setup_camera)
        .add_plugins((menu::MenuPlugin, game::GamePlugin, game_over::GameOverPlugin))
        .run();
}

fn setup_camera(mut commands: Commands) {
    commands.spawn(Camera2d);
}
