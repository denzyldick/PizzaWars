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
    private PizzaBoy enemy;
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
    gotHim();
    rotate();
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
    
    public PizzaBoy getOwner()
    {
        return this.owner;
    }
    
    private void gotHim()
    {try{
        PizzaBoy enemy = (PizzaBoy)this.getOneIntersectingObject(PizzaBoy.class);
        if(enemy != this.owner)
        {
         enemy.setLocation(360,40);
         getWorld().removeObject(this);
        /**
         * GOT HIM
         */    
        }
    }catch(Exception e)
    {
        
    }
        
    }
    private void rotate()
    {       if(getRotation() >359)
       {
           setRotation(0);
        }
        setRotation((getRotation() + SPEED));

    }
}
