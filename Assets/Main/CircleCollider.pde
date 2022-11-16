public class CircleCollider extends Collider
{
    /* Members. */
    private PVector m_CenterOffset = new PVector();
    private PVector m_OurPosition;
    private float m_Radius = 30f;

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
        PVector checkPosition = collider.transform().Position;
        float checkRadius = collider.GetRadius();

        float dist = checkPosition.dist(transform().Position);
        if (dist < (m_Radius + checkRadius))
        {
            fill(m_OnCollisionColor);
        }
        fill(255);
    }

    @Override
    public void CollideAgainstBox(BoxCollider collider)
    {
        PVector checkPosition = collider.GetCenter();

        PVector circleToBoxDir = PVector.sub(checkPosition, transform().Position).normalize();

        // Get outer point on circle in the direction of the box to test
        PVector outerPoint = PVector.add(transform().Position, circleToBoxDir.mult(m_Radius));

        circle(outerPoint.x, outerPoint.y, 5);

        // If the outer point in inside the box there is a collision
        if (collider.PointInCollider(outerPoint))
        {
            RaiseOnCollisionEnterEvent(new CollisionInfo(new PVector(), collider));
        }
    }

    @Override
    public void DrawCollider()
    {
        circle(transform().Position.x, transform().Position.y, m_Radius*2);
    }

    @Override
    public void ResolveCollision(CollisionInfo collisionInfo)
    {
        if (m_IsStatic)
        {

        }
        else
        {
            println("Resolving collsion for " + collisionInfo.Collider.GetName());
        }
    }
}