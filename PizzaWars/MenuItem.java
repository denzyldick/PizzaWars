import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

public abstract class MenuItem extends Actor
{
    protected final int SPEED = 5;
    protected boolean  left;

    public abstract void act();
    protected void move()
    {
        if(left)
        {
        if(this.getX()>300)
        {
        setLocation((this.getX() - SPEED),this.getY());
    }}else if(!left)
    {
        if(this.getX()<300)
        {
         setLocation((this.getX() + SPEED),this.getY());
        }
    }
    }
        
}
