import greenfoot.*;
import java.util.List;
import java.util.ArrayList;

public class PizzaBoy extends Actor
{
    private static final int SPEED = 2;
    private static final int FALLING_SPEED = 5;
    private static final int JUMP_LIMIT = 10;
    private static final int FRAMES = 8;
    private static final int FRAME_SKIP_INTERVAL = 6;
    private static final int HEART_SPACING = 22;
    private static final int INITIAL_LIVES = 3;
    private static final int SCREEN_EDGE_BUFFER = 3;
    private static final int COLLISION_HITBOX_INSET = 20;

    private int frame;
    private int animationCount;
    private int jumpTimer;
    private final int spawnX;
    private final int spawnY;
    private boolean falling;
    private boolean jumping;
    private String facing;

    private GreenfootImage[] rightFacing;
    private GreenfootImage[] leftFacing;
    private final String[] keys;
    private final List<Heart> lives;
    private final GreenfootSound throwSound;
    private final GreenfootSound hitSound;

    public PizzaBoy(String color, String left, String right, String jump, String shoot, int spawnX, int spawnY)
    {
        this.spawnX = spawnX;
        this.spawnY = spawnY;
        this.keys = new String[]{left, right, jump, shoot};
        facing = "right";
        falling = true;

        rightFacing = new GreenfootImage[FRAMES];
        leftFacing = new GreenfootImage[FRAMES];
        lives = new ArrayList<>(INITIAL_LIVES);
        throwSound = new GreenfootSound("throw.mp3");
        hitSound = new GreenfootSound("hit.mp3");

        loadAnimationFrames(color);
        for (int i = 0; i < INITIAL_LIVES; i++)
        {
            lives.add(new Heart());
        }
    }

    @Override
    public void addedToWorld(World world)
    {
        int x = spawnX;
        for (Heart heart : lives)
        {
            world.addObject(heart, x, spawnY);
            x += HEART_SPACING;
        }
    }

    private void loadAnimationFrames(String color)
    {
        rightFacing[0] = new GreenfootImage(color + "/playerIdle0R.png");
        rightFacing[1] = new GreenfootImage(color + "/playerWalking0R.png");
        rightFacing[2] = new GreenfootImage(color + "/playerWalking1R.png");
        rightFacing[3] = new GreenfootImage(color + "/playerWalking2R.png");
        rightFacing[4] = new GreenfootImage(color + "/playerWalking3R.png");
        rightFacing[5] = new GreenfootImage(color + "/playerWalking4R.png");
        rightFacing[6] = new GreenfootImage(color + "/playerWalking5R.png");
        rightFacing[7] = new GreenfootImage(color + "/playerJumpingR.png");

        leftFacing[0] = new GreenfootImage(color + "/playerIdle0L.png");
        leftFacing[1] = new GreenfootImage(color + "/playerWalking0L.png");
        leftFacing[2] = new GreenfootImage(color + "/playerWalking1L.png");
        leftFacing[3] = new GreenfootImage(color + "/playerWalking2L.png");
        leftFacing[4] = new GreenfootImage(color + "/playerWalking3L.png");
        leftFacing[5] = new GreenfootImage(color + "/playerWalking4L.png");
        leftFacing[6] = new GreenfootImage(color + "/playerWalking5L.png");
        leftFacing[7] = new GreenfootImage(color + "/playerJumpingL.png");
    }

    public int getLives()
    {
        return lives.size();
    }

    public void removeLives()
    {
        if (lives.isEmpty())
        {
            return;
        }
        hitSound.play();
        Heart heart = lives.remove(lives.size() - 1);
        getWorld().removeObject(heart);
    }

    @Override
    public void act()
    {
        collisionDetection();
        handleInput();
        if (falling)
        {
            fall();
        }
        if (jumping)
        {
            jump();
        }
        animationCount++;
    }

    private void moveRight()
    {
        setLocation(getX() + SPEED, getY());
        if (getX() + rightFacing[0].getWidth() > getWorld().getWidth() - SCREEN_EDGE_BUFFER)
        {
            setLocation(0, getY());
        }
        facing = "right";
        advanceAnimation();
    }

    private void moveLeft()
    {
        setLocation(getX() - SPEED, getY());
        if (getX() <= 0)
        {
            setLocation(getWorld().getWidth(), getY());
        }
        facing = "left";
        advanceAnimation();
    }

    private void advanceAnimation()
    {
        if (animationCount % FRAME_SKIP_INTERVAL != 0)
        {
            return;
        }
        animationCount = 0;
        frame = (frame + 1) % FRAMES;
        if (frame == 0 || frame == FRAMES - 2)
        {
            return;
        }
        setImage(facing.equals("right") ? rightFacing[frame] : leftFacing[frame]);
    }

    private void jump()
    {
        setLocation(getX(), getY() - FALLING_SPEED);
        jumpTimer++;
        if (jumpTimer > JUMP_LIMIT)
        {
            jumping = false;
            falling = true;
            jumpTimer = 0;
        }
    }

    private void fall()
    {
        if (!jumping)
        {
            setLocation(getX(), getY() + FALLING_SPEED);
        }
    }

    private void collisionDetection()
    {
        Platform platform = (Platform) getOneIntersectingObject(Platform.class);
        if (platform == null)
        {
            falling = true;
            return;
        }

        GreenfootImage platformImage = platform.getImage();
        boolean standingOnPlatform = getY() < platform.getY()
            && getX() + platformImage.getWidth() > platform.getX()
            && getY() != platform.getY() - platformImage.getHeight() / 2;

        if (standingOnPlatform)
        {
            setLocation(getX(), platform.getY() - platformImage.getHeight());
            falling = false;
            jumpTimer = 0;
        }

        if (getX() + (rightFacing[0].getWidth() - COLLISION_HITBOX_INSET) < platform.getX())
        {
            falling = true;
        }
    }

    private void shoot()
    {
        List<PizzaSlice> slices = getWorld().getObjects(PizzaSlice.class);
        if (slices.isEmpty() || slices.get(0).getOwner() != this)
        {
            throwSound.play();
            getWorld().addObject(new PizzaSlice(this, facing), getX(), getY());
        }
    }

    private void handleInput()
    {
        if (Greenfoot.isKeyDown(keys[1]))
        {
            moveRight();
        }
        else if (Greenfoot.isKeyDown(keys[0]))
        {
            moveLeft();
        }
        else if (Greenfoot.isKeyDown(keys[2]))
        {
            if (!falling)
            {
                falling = false;
                jumping = true;
            }
        }
        else if (Greenfoot.isKeyDown(keys[3]))
        {
            shoot();
        }
        else
        {
            setImage(facing.equals("right") ? rightFacing[0] : leftFacing[0]);
        }
    }

    public int getSpawnX()
    {
        return spawnX;
    }

    public int getSpawnY()
    {
        return spawnY;
    }
}
