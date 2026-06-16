# GitHub Backlog

Use this as the source of truth for GitHub Projects issues and milestones.

## Milestones

### M1: Godot Prototype

Goal: playable local version in Godot with the same core feel as the current game.

### M2: Local Multiplayer Parity

Goal: two-player local match with complete game flow and polish.

### M3: Server-Authoritative Multiplayer

Goal: backend-driven match state with connected clients.

### M4: Online Beta

Goal: stable internet play with basic operational tooling.

## Epic: Godot Migration

### Issue: Create Godot project skeleton

Labels: `godot-migration`

Acceptance criteria:

- Godot 4 project opens cleanly.
- Scenes exist for menu, match, HUD, and game over.
- Input actions are defined for both players.

### Issue: Import and normalize assets

Labels: `godot-migration`

Acceptance criteria:

- Sprites and audio are imported into a clean structure.
- Player, platform, projectile, and UI assets are available in Godot.

### Issue: Rebuild player controller

Labels: `godot-migration`

Acceptance criteria:

- Players can move left and right.
- Players can jump.
- Facing direction updates correctly.

### Issue: Rebuild pizza projectile behavior

Labels: `godot-migration`

Acceptance criteria:

- Players can throw projectiles.
- Projectiles move consistently and can be cleaned up off-screen.

### Issue: Rebuild collision and damage flow

Labels: `godot-migration`

Acceptance criteria:

- Players take damage on hit.
- Lives decrement correctly.
- Match ends when a player reaches zero lives.

### Issue: Rebuild HUD and game over flow

Labels: `godot-migration`

Acceptance criteria:

- Lives are visible in-game.
- Win/loss screen transitions work.

## Epic: Multiplayer Backend

### Issue: Define network state contract

Labels: `backend`, `networking`

Acceptance criteria:

- Client input messages are defined.
- Server state snapshot format is defined.
- Match start and end messages are defined.

### Issue: Choose transport and protocol

Labels: `backend`, `networking`

Acceptance criteria:

- A transport choice is documented.
- Message framing and serialization format are documented.

### Issue: Build headless match server

Labels: `backend`

Acceptance criteria:

- Server can run without rendering.
- Server can host a single match.
- Server can advance game simulation tick by tick.

### Issue: Add lobby and matchmaking

Labels: `backend`

Acceptance criteria:

- Players can create or join a match.
- Two players can be paired into a session.

### Issue: Connect Godot client to server

Labels: `backend`, `networking`

Acceptance criteria:

- Client sends input to server.
- Client renders state from server snapshots.

### Issue: Add disconnect handling

Labels: `backend`, `networking`

Acceptance criteria:

- Match ends or pauses cleanly when a client disconnects.
- Server cleans up orphaned sessions.

### Issue: Add latency tolerance

Labels: `backend`, `networking`

Acceptance criteria:

- Client feels responsive under moderate latency.
- State interpolation is implemented or explicitly deferred.

### Issue: Add deployment notes

Labels: `backend`, `qa`

Acceptance criteria:

- Server startup instructions are written.
- Basic hosting requirements are documented.

## Recommended order

1. Create Godot project skeleton
2. Import and normalize assets
3. Rebuild player controller
4. Rebuild pizza projectile behavior
5. Rebuild collision and damage flow
6. Rebuild HUD and game over flow
7. Define network state contract
8. Choose transport and protocol
9. Build headless match server
10. Add lobby and matchmaking
11. Connect Godot client to server
12. Add disconnect handling
13. Add latency tolerance
14. Add deployment notes

