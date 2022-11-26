public class PreyControlDisplayObject extends GameObject
{
    public PreyControlDisplayObject()
    {
        super("Prey Control Display");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        AddComponent(new PreyControlDisplay());
    }
}

public class PreyControlDisplay extends AnimalControlDisplay
{
    public PreyControlDisplay()
    {
        super();
    }
}