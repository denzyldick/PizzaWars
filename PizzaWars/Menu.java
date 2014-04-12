import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)
/**
 * Write a description of class Menu here.
 * 
 * @author Denzyl Dick
 * @version 0.1
 */
public class Menu extends World
{

    /**
     * Constructor for objects of class Menu.
     * 
     */
    private Logo logo   =   new Logo();
    private StartButton startButton = new StartButton();
    private PlayArea playArea   = new PlayArea();
    
    public Menu()
    {    
        // Create a new world with 600x400 cells with a cell size of 1x1 pixels.
        super(600, 400, 1); 
        addObject(logo,300,100);
        addObject(startButton,300,200);
    
     }
}
