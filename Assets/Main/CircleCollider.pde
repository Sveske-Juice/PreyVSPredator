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
    public void DrawCollider()
    {
        circle(transform().Position.x, transform().Position.y, m_Radius*2);
    }

    @Override
    public CollisionPoint TestCollision(Collider collider)
    {
        // Seecond dispatch to reveal concrete class (CircleCollider)
        return collider.TestCollision(this);
    }

    @Override
    public CollisionPoint TestCollision(CircleCollider collider)
    {
        PVector checkPosition = collider.transform().Position;
        float checkRadius = collider.GetRadius();

        float dist = checkPosition.dist(transform().Position); // Dist between centers
        if (dist < m_Radius + checkRadius)
        {
            // They're colliding
            // A is this collider and B is the collider to check
            PVector Normal = PVector.sub(checkPosition, transform().Position).normalize();
            PVector A = PVector.add(transform().Position, PVector.mult(Normal, m_Radius)); // Furthest point of A into B
            PVector B = PVector.add(checkPosition, Normal.copy().rotate(PI).mult(checkRadius));

            return new CollisionPoint(A, B, Normal, true);
        }

        // No collision happened set HasCollision flag to false.
        return new CollisionPoint(null, null, null, false);
    }

    @Override
    public CollisionPoint TestCollision(BoxCollider collider)
    {
        PVector boxCenter = collider.GetCenter();
        PVector boxHalfExtents = new PVector(collider.GetWidth() / 2f, collider.GetHeight() / 2f);

        PVector diff = PVector.sub(transform().Position, boxCenter);
        PVector clamped = Clamp(diff, PVector.mult(boxHalfExtents, -1f), boxHalfExtents);

        PVector closestPoint = PVector.add(boxCenter, clamped);

        PVector circleToPoint = PVector.sub(closestPoint, transform().Position);
        float ctpMag = circleToPoint.mag();

        if (ctpMag > m_Radius) // No collision happened
            return new CollisionPoint(null, null, null, false);

        // Calculate the collision points of the collision
        PVector A = PVector.add(transform().Position, PVector.mult(circleToPoint.copy().normalize(), m_Radius)); // Furthest point of circle penetrated ino AABB

        // if circle completely inside use the point on the circles outline in the dir of the aabb
        if (circleToPoint.x == 0f && circleToPoint.y == 0f)
            A = PVector.add(transform().Position, PVector.mult(PVector.sub(boxCenter, transform().Position).normalize(), m_Radius));
        

        fill(255,0,0);
        circle(closestPoint.x, closestPoint.y, 15);
        circle(A.x, A.y, 15);
        fill(255);

        return new CollisionPoint(A, closestPoint, PVector.sub(closestPoint, A).normalize(), true);
        
    }

    /// Clamps a vector between a min and max vector
    private PVector Clamp(PVector value, PVector min, PVector max)
    {
        PVector out = value.copy();
        out.x = Clamp(out.x, min.x, max.x);
        out.y = Clamp(out.y, min.y, max.y);
        return out;
    }
}