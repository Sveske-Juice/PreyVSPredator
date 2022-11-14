public abstract class Animal extends GameObject 
{    
    public Animal(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();
        AddComponent(new MoveController());

        AddComponent(new Polygon(createShape(RECT, 2, 2, 10, 10)));
    }
}

public class AnimalMover extends Component
{
    /* Members. */
    protected float m_MovementSpeed = 1f;
}
