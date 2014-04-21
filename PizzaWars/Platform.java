import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class Platform here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Platform extends Actor
{
    /**
     * Act - do whatever the Platform wants to do. This method is called whenever
     * the 'Act' or 'Run' button gets pressed in the environment.
     */
    private final int DISTANCE_MAX = 30;
    private int distance = 0;
    private final int SPEED = 2;
    private boolean moving;

    
    public void act() 
    {
        if(moving)
        {      
                up();
              if(getY() == 0)
              {
              setLocation(this.getX(), getWorld().getHeight());    
              }
                             
        }
    }    
    public Platform(boolean moving, int distance)
    {
        this.moving = moving;
        this.distance = distance;
        setImage("platformDark.png");//set another platform image

    }
    public Platform()
    {
        moving = false;
    }
    public void up(){
        this.setLocation(getX(),this.getY() - SPEED);
    }
    
    public void down(){
        
        this.setLocation(getX(),this.getY() + SPEED);
    }
}
