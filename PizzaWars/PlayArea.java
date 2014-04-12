import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class PlayArea here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PlayArea extends World
{

    /**
     * Constructor for objects of class PlayArea.
     * 
     */
    final int FIRST_ROW =   100;
    final int SECOND_ROW  =240;
    final int THIRD_ROW   = 500;

    
    public PlayArea()
    {    
        // Create a new world with 600x400 cells with a cell size of 1x1 pixels.
        super(600, 400, 1);
        generatePlatforms();
        addObject(new PizzaBoy(true,"a","d","w","s"), 100,40);
        addObject(new PizzaBoy(true,"left","right","up","down"), 100,40);
    }
   
    private void generatePlatforms()
    {
        
      addObject(new Platform(),100,FIRST_ROW);
      addObject(new Platform(),360,SECOND_ROW);
      addObject(new Platform(),220,THIRD_ROW);
  
    }
}
