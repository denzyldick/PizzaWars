import greenfoot.*;

public class PizzaSlice extends Actor
{
    private static final int SPEED = 3;
    private static final int FULL_ROTATION = 360;

    private final PizzaBoy owner;
    private final String direction;

    public PizzaSlice(PizzaBoy owner, String direction)
    {
        this.owner = owner;
        this.direction = direction;
    }

    public PizzaBoy getOwner()
    {
        return owner;
    }

    @Override
    public void act()
    {
        if (direction.equals("right"))
        {
            setLocation(getX() + SPEED, getY());
        }
        else
        {
            setLocation(getX() - SPEED, getY());
        }
        removeIfOffScreen();
        checkHit();
        rotate();
    }

    private void removeIfOffScreen()
    {
        GreenfootImage img = getImage();
        if (getX() - img.getWidth() < 0 || getX() + img.getWidth() > getWorld().getWidth())
        {
            getWorld().removeObject(this);
        }
    }

    private void checkHit()
    {
        PizzaBoy enemy = (PizzaBoy) getOneIntersectingObject(PizzaBoy.class);
        if (enemy == null || enemy == owner)
        {
            return;
        }

        enemy.setLocation(owner.getSpawnX(), owner.getSpawnY());
        enemy.removeLives();
        getWorld().removeObject(this);
    }

    private void rotate()
    {
        int rotation = getRotation() + SPEED;
        if (rotation >= FULL_ROTATION)
        {
            rotation -= FULL_ROTATION;
        }
        setRotation(rotation);
    }
}
