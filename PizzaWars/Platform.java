import greenfoot.*;

public class Platform extends Actor
{
    private static final int SPEED = 2;
    private static final int WORLD_WRAP_Y = 0;

    private boolean moving;

    public Platform(boolean moving, int distance)
    {
        this.moving = moving;
        setImage("platformDark.png");
    }

    public Platform()
    {
        this.moving = false;
    }

    @Override
    public void act()
    {
        if (!moving)
        {
            return;
        }
        setLocation(getX(), getY() - SPEED);
        if (getY() <= WORLD_WRAP_Y)
        {
            setLocation(getX(), getWorld().getHeight());
        }
    }
}
