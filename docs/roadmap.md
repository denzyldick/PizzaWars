# Pizza Wars Roadmap

This roadmap splits the work into two tracks:

1. Godot client migration
2. Multiplayer backend

The goal is to preserve the existing game feel while moving the codebase to a Godot-first runtime with a server-authoritative network model.

## Phase 0: Project setup

- Create a Godot 4 project.
- Import and normalize sprites, audio, and UI assets.
- Define input actions for both players.
- Establish the initial scene tree:
  - `Menu`
  - `Game`
  - `Player`
  - `Platform`
  - `Projectile`
  - `HUD`
  - `GameOver`

## Phase 1: Core gameplay in Godot

- Recreate player movement, jumping, and facing.
- Recreate pizza throwing and projectile movement.
- Recreate collision, damage, lives, and win conditions.
- Match the original timing and feel before adding new features.
- Verify single-machine local multiplayer first.

## Phase 2: Multiplayer architecture

- Choose an authoritative server model.
- Define the game state contract between client and server.
- Decide the transport layer:
  - WebSocket for easier compatibility.
  - ENet/UDP only if latency becomes a problem.
- Separate simulation from presentation so the same rules can run on the backend.

## Phase 3: Backend implementation

- Create a headless match server.
- Implement lobby/session creation.
- Implement player pairing and match start.
- Add real-time state sync.
- Add disconnect handling and match cleanup.

## Phase 4: Client networking

- Send player input to the server.
- Render server state on the client.
- Add interpolation and, if necessary, prediction/reconciliation.
- Keep local input responsive while respecting server authority.

## Phase 5: Validation and release prep

- Test local play, LAN play, and internet play.
- Measure latency sensitivity and tune sync frequency.
- Add logging for server events and desync debugging.
- Prepare deployment and hosting strategy.

## GitHub project structure

Recommended GitHub issue buckets:

- `godot-migration`
- `backend`
- `networking`
- `qa`

Recommended milestone order:

1. Godot prototype
2. Local multiplayer parity
3. Server-authoritative multiplayer
4. Online beta

## Suggested first issues

1. Create Godot project skeleton and import assets.
2. Rebuild player controller and projectile behavior.
3. Recreate map, platforms, and HUD.
4. Add game state flow and game-over handling.
5. Define networking contract and server message schema.
6. Stand up headless backend prototype.
7. Connect client input to server simulation.
8. Add latency and disconnect handling.

