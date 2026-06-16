import greenfoot.*;

public abstract class MenuItem extends Actor
{
    private static final int SPEED = 5;
    private static final int CENTER_X = 300;

    protected boolean left;

    @Override
    public abstract void act();

    protected void move()
    {
        if (left && getX() > CENTER_X)
        {
            setLocation(getX() - SPEED, getY());
        }
        else if (!left && getX() < CENTER_X)
        {
            setLocation(getX() + SPEED, getY());
        }
    }
}
