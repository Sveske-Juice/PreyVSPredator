public class CircleCollider extends Collider
{
    /* Members. */
    private PVector m_CenterOffset = new PVector();
    private PVector m_OurPosition;
    private float m_Radius = 75f;
    private PVector m_LocalExtentOffset = new PVector(m_Radius, m_Radius);

    /* Getters/Setters. */
    public float GetRadius() { return m_Radius; }
    public void SetRadius(float radius) { m_Radius = radius; m_LocalExtentOffset = new PVector(m_Radius, m_Radius); }

    /* Pass name with initialization. */
    public CircleCollider(String name)
    {
        super(name);
    }

    /* Initialize with specified radius. */
    public CircleCollider(String name, float radius)
    {
        super(name);
        m_Radius = radius;
    }

    /* Default constructor. */
    public CircleCollider() { super("Circle Collider"); }


    @Override
    public void DrawCollider()
    {
        // println("radius on " + GetName() + " : " + m_Radius);
        // println("min extent: " + GetMinExtents().x);'
        // println("max extent: " + GetMaxExtents().x);'
        circle(transform().GetPosition().x, transform().GetPosition().y, m_Radius*2);
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
        PVector checkPosition = collider.transform().GetPosition();
        PVector pos = transform().GetPosition();

        float checkRadius = collider.GetRadius();

        // Don't use processing default dist() function, because it's sloow        
        float dist = sqrt(pow(pos.x - checkPosition.x, 2) + pow(pos.y - checkPosition.y, 2));
        if (dist < m_Radius + checkRadius)
        {
            // They're colliding
            // A is this collider and B is the collider to check
            PVector Normal = PVector.sub(checkPosition, transform().GetPosition()).normalize();
            PVector A = PVector.add(transform().GetPosition(), PVector.mult(Normal, m_Radius)); // Furthest point of A into B
            PVector B = PVector.add(checkPosition, Normal.copy().rotate(PI).mult(checkRadius));
            return new CollisionPoint(A, B, Normal, true);
        }

        // No collision happened
        return null;
    }

    @Override
    public CollisionPoint TestCollision(BoxCollider collider)
    {
        PVector boxCenter = collider.GetCenter();
        PVector boxHalfExtents = new PVector(collider.GetWidth() / 2f, collider.GetHeight() / 2f);

        PVector diff = PVector.sub(transform().GetPosition(), boxCenter);
        PVector clamped = Clamp(diff, PVector.mult(boxHalfExtents, -1f), boxHalfExtents);

        PVector closestPoint = PVector.add(boxCenter, clamped);

        PVector circleToPoint = PVector.sub(closestPoint, transform().GetPosition());
        float ctpMag = circleToPoint.mag();

        if (ctpMag > m_Radius) // No collision happened
            return null;

        // Calculate the collision points of the collision
        PVector A = PVector.add(transform().GetPosition(), PVector.mult(circleToPoint.copy().normalize(), m_Radius)); // Furthest point of circle penetrated ino AABB

        // if circle completely inside use the point on the circles outline in the dir of the aabb
        if (circleToPoint.x == 0f && circleToPoint.y == 0f)
            A = PVector.add(transform().GetPosition(), PVector.mult(PVector.sub(boxCenter, transform().GetPosition()).normalize(), m_Radius));
        

        // fill(255,0,0);
        // circle(closestPoint.x, closestPoint.y, 15);
        // circle(A.x, A.y, 15);
        // fill(255);

        return new CollisionPoint(A, closestPoint, PVector.sub(closestPoint, A).normalize(), true);
        
    }

    @Override
    public RaycastHit TestRaycast(Ray ray)
    {
        PVector pos = transform().GetPosition();

        // TODO take offset into account here
        PVector originToCircle = PVector.sub(pos, ray.GetOrigin());
        float radiusSq = m_Radius * m_Radius;
        float originToCircleMagSq = originToCircle.mag() * originToCircle.mag();

        // Project origin>ToCircle vector (E) onto ray direction axis
        float a = originToCircle.dot(ray.GetDir());
        float bSq = originToCircleMagSq - (a * a);

        if (radiusSq - bSq < 0f)
        {
            // No intersection
            return new RaycastHit(null, null, -1f, false);
        }

        float f = sqrt(radiusSq - bSq);
        float t = 0f;

        if (originToCircleMagSq < radiusSq) // Ray's origin is inside of the circle
        {
            t = a + f;
        }
        else
        {
            t = a - f;
        }


        PVector point = PVector.add(ray.GetOrigin(), PVector.mult(ray.GetDir(), t));
        PVector normal = PVector.sub(point, pos).normalize();
        
        /* debug
        println("Ray cast hit!!!");
        fill(255, 0, 0);
        circle(ray.GetOrigin().x, ray.GetOrigin().y, 15);
        circle(point.x, point.y, 15);
        fill(255);
        */
        
        return new RaycastHit(normal, point, t, true);
    }

    @Override
    public boolean PointInCollider(PVector point)
    {
        // TODO take offset into account here
        PVector pos = transform().GetPosition(); // cache pos
        PVector screenPosition = new PVector(screenX(pos.x, pos.y), screenY(pos.x, pos.y));
        float dist = screenPosition.dist(point);

        if (dist < m_Radius * m_GameObject.GetBelongingToScene().GetScaleFactor())
            return true;

        return false;
    }


    @Override
    public PVector GetMinExtents()
    {
        // TODO take offset into account here
        return PVector.sub(transform().GetPosition(), new PVector(m_Radius, m_Radius));
    }

    @Override
    public PVector GetMaxExtents()
    {
        // TODO take offset into account here
        return PVector.add(transform().GetPosition(), new PVector(m_Radius, m_Radius));
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