public class CircleCollider extends Collider
{
    /* Members. */
    private PVector m_CenterOffset = new PVector();
    private PVector m_OurPosition;
    private float m_Radius = 100f;

    /* Getters/Setters. */
    public float GetRadius() { return m_Radius; }
    public void SetRadius(float radius) { m_Radius = radius; }

    /* Pass name with initialization. */
    public CircleCollider(String name)
    {
        super(name);
    }

    /* Default constructor. */
    public CircleCollider() { super("Circle Collider"); }

    @Override
    public boolean PointInCollider(PVector point)
    {
        return false;
    }

    @Override
    public void CollideAgainstCircle(CircleCollider collider)
    {
        PVector checkPosition = collider.GetGameObject().GetTransform().Position;
        float checkRadius = collider.GetRadius();

        float dist = dist(m_GameObject.GetTransform().Position.x, m_GameObject.GetTransform().Position.y, m_GameObject.GetTransform().Position.x, m_GameObject.GetTransform().Position.y);
        println("dist: " + dist + " radius: " + m_Radius);
        if (dist < (m_Radius + checkRadius))
        {
            println("Collision!!!");
            fill(255, 0, 0);
        }
        fill(255);
    }

    @Override
    public void CollideAgainstBox(BoxCollider collider)
    {
        PVector checkPosition = collider.GetCenter();

        float distBetweenCenters = m_GameObject.GetTransform().Position.dist(checkPosition);
        PVector circleToBoxDir = PVector.sub(checkPosition, m_GameObject.GetTransform().Position).normalize();
        PVector outerPoint = PVector.add(m_GameObject.GetTransform().Position, circleToBoxDir.mult(m_Radius));

        println(outerPoint);
        circle(outerPoint.x, outerPoint.y, 5);
        println(collider.PointInCollider(outerPoint));
    }

    @Override
    public void DrawCollider()
    {
        println(m_GameObject.GetTransform().Position);
        circle(m_GameObject.GetTransform().Position.x, m_GameObject.GetTransform().Position.y, m_Radius*2);
    }
}