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
        
        AddComponent(new Polygon(createShape(RECT, 2, 2, 10, 10)));
    }
}

public class AnimalMover extends Component
{
    /* Members. */
    protected float m_MovementSpeed = 25f;

    /* Getters/Setters. */
    public float GetMovementSpeed() { return m_MovementSpeed; }
}
