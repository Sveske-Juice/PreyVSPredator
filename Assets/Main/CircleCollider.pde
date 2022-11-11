public class CircleCollider extends Collider
{
    /* Members. */
    private PVector m_CenterOffset = new PVector();
    private float m_Radius = 1f;

    /* Pass name with initialization. */
    public CircleCollider(String name)
    {
        super(name);
    }

    /* Default constructor. */
    public CircleCollider() { super("Circle Collider"); }

    @Override
    public void CollideAgainstCircle(CircleCollider collider)
    {

    }
}