import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class PizzaSlice here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PizzaSlice extends Actor
{
    public PizzaBoy owner;
    private int SPEED = 3;
    private String direction;
    private GreenfootImage image;
    
    public void act() 
    {
        if(direction.equals("right"))
        {
        this.setLocation((this.getX() + this.SPEED), this.getY());
    }else if(direction.equals("left"))
    {
        this.setLocation((this.getX() - this.SPEED),this.getY());
    }
    touchedBorder();
 
    }    
    public PizzaSlice(PizzaBoy owner,String direction)
    {
        this.owner = owner;
        this.direction = direction;
        image = this.getImage();
    }
    
    private void touchedBorder()
    {
        if((this.getX() - this.image.getWidth()) < 0)
        {
            getWorld().removeObject(this);
        }else if(this.getX()+ image.getWidth() > (getWorld().getWidth()))
        {
            getWorld().removeObject(this);
        }
    }
}
