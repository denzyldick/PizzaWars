import greenfoot.*;

public class Start extends MenuItem
{
    @Override
    public void act()
    {
        left = false;
        move();
        if (Greenfoot.mouseClicked(this))
        {
            Greenfoot.setWorld(new PlayArea());
        }
    }
}
