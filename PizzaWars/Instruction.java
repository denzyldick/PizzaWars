import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

/**
 * Write a description of class Instruction here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Instruction extends MenuItem
{
    private GreenfootImage instruction = new GreenfootImage("InstructionsButton.png");
    private GreenfootImage image = new GreenfootImage("instructionscreen.png");
    private boolean showInstruction = true;
    public void act() 
    {
        left = true;
        move();
       if(Greenfoot.mouseClicked(this))
        {
            if(showInstruction)
            {
                showInstruction = false;
               setImage(image);
            }else
            {
                showInstruction = true;
                setImage(instruction);
            }
        }
       
    }  
    
 
}
