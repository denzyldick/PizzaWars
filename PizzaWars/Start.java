import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * This class handles the StartButtton
 * 
 * @author Denzyl Dick 
 * @version 0.1
 */
public class Start extends MenuItem
{
    /**
     * Act - do whatever the StartButton wants to do. This method is called whenever
     * the 'Act' or 'Run' button gets pressed in the environment.
     */
    public void act() 
    {left = false;
        move();
       
        if(Greenfoot.mouseClicked(this))
        {
            Greenfoot.setWorld(new PlayArea());
        }
    }   
    
}
