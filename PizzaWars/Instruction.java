import greenfoot.*;

public class Instruction extends MenuItem
{
    private final GreenfootImage buttonImage;
    private final GreenfootImage instructionImage;
    private boolean showingInstruction;

    public Instruction()
    {
        buttonImage = new GreenfootImage("InstructionsButton.png");
        instructionImage = new GreenfootImage("instructionscreen.png");
        showingInstruction = false;
    }

    @Override
    public void act()
    {
        left = true;
        if (!showingInstruction)
        {
            move();
        }
        if (Greenfoot.mouseClicked(this))
        {
            showingInstruction = !showingInstruction;
            setImage(showingInstruction ? instructionImage : buttonImage);
        }
    }
}
