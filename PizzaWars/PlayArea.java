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

    final int GROUND   = 500;
    PizzaBoy redBoy = new PizzaBoy("red","a","d","w","s",8,12);
    PizzaBoy greenBoy = new PizzaBoy("green","left","right","up","down",this.getWidth()-90,12);
    
    
    public PlayArea()
    {    
        // Create a new world with 600x400 cells with a cell size of 1x1 pixels.
        super(600, 400, 1);
        generatePlatforms();
        addObject(redBoy, 100,40);
        addObject(greenBoy, 360,40);
    }
   
    private void generatePlatforms()
    {
      addObject(new Platform(),1,99);
      addObject(new Platform(),100,100);
      addObject(new Platform(),211,124);
      addObject(new Platform(),373,127);
      addObject(new Platform(),559,74);
      addObject(new Platform(true,30),515,224);
      addObject(new Platform(),312,276);   
      addObject(new Platform(true,10),103,337);
      /**
       * Ground
       */
      int i=0;
      int pos =  0;
      while( i < 7)
      {
       
      addObject(new Platform(),pos,GROUND);
      pos += 97;
      i++;
    }
      
   
    }
    
    public void act()
    {
        
        if(redBoy.getLives() == 0)
        {
            Greenfoot.setWorld(new LostScreen());

        }else if(greenBoy.getLives() == 0)
        {
           Greenfoot.setWorld(new LostScreen());   
        }
    }
}
