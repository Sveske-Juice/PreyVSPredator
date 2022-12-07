public class CircleCollider extends Collider
{
    /* Members. */
    private ZVector m_CenterOffset = new ZVector();
    private ZVector m_OurPosition;
    private float m_Radius = 75f;
    private ZVector m_LocalExtentOffset = new ZVector(m_Radius, m_Radius);

    /* Getters/Setters. */
    public float GetRadius() { return m_Radius; }
    public void SetRadius(float radius) { m_Radius = radius; m_LocalExtentOffset = new ZVector(m_Radius, m_Radius); }
    
    @Override
    public ZVector GetCenter() { return transform().GetPosition(); }

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
        ZVector checkPosition = collider.transform().GetPosition();
        ZVector pos = transform().GetPosition();

        float checkRadius = collider.GetRadius();

        // Don't use processing default dist() function, because it's sloow        
        float dist = sqrt(pow(pos.x - checkPosition.x, 2) + pow(pos.y - checkPosition.y, 2));
        if (dist < m_Radius + checkRadius)
        {
            // They're colliding
            // A is this collider and B is the collider to check
            ZVector Normal = ZVector.sub(checkPosition, transform().GetPosition()).normalize();
            ZVector A = ZVector.add(transform().GetPosition(), ZVector.mult(Normal, m_Radius)); // Furthest point of A into B
            ZVector B = ZVector.add(checkPosition, Normal.copy().rotate(PI).mult(checkRadius));
            return new CollisionPoint(A, B, Normal, true);
        }

        // No collision happened
        return null;
    }

    @Override
    public CollisionPoint TestCollision(BoxCollider collider)
    {
        ZVector boxCenter = collider.GetCenter();
        ZVector boxHalfExtents = new ZVector(collider.GetWidth() / 2f, collider.GetHeight() / 2f);

        ZVector diff = ZVector.sub(transform().GetPosition(), boxCenter);
        ZVector clamped = Clamp(diff, ZVector.mult(boxHalfExtents, -1f), boxHalfExtents);

        ZVector closestPoint = ZVector.add(boxCenter, clamped);

        ZVector circleToPoint = ZVector.sub(closestPoint, transform().GetPosition());
        float ctpMag = circleToPoint.mag();

        if (ctpMag > m_Radius) // No collision happened
            return null;

        // Calculate the collision points of the collision
        ZVector A = ZVector.add(transform().GetPosition(), ZVector.mult(circleToPoint.copy().normalize(), m_Radius)); // Furthest point of circle penetrated ino AABB

        // if circle completely inside use the point on the circles outline in the dir of the aabb
        if (circleToPoint.x == 0f && circleToPoint.y == 0f)
            A = ZVector.add(transform().GetPosition(), ZVector.mult(ZVector.sub(boxCenter, transform().GetPosition()).normalize(), m_Radius));
        

        // fill(255,0,0);
        // circle(closestPoint.x, closestPoint.y, 15);
        // circle(A.x, A.y, 15);
        // fill(255);

        return new CollisionPoint(A, closestPoint, ZVector.sub(closestPoint, A).normalize(), true);
        
    }

    @Override
    public RaycastHit TestRaycast(Ray ray)
    {
        ZVector pos = transform().GetPosition();

        // TODO take offset into account here
        ZVector originToCircle = ZVector.sub(pos, ray.GetOrigin());
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


        ZVector point = ZVector.add(ray.GetOrigin(), ZVector.mult(ray.GetDir(), t));
        ZVector normal = ZVector.sub(point, pos).normalize();
        
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
    public boolean PointInCollider(ZVector point)
    {
        // TODO take offset into account here
        ZVector pos = transform().GetPosition(); // cache pos
        if (!m_GameObject.IsFixed())
        {
            // If it's not a fixed/static collider (not ui object) then compare using screen coordiantes
            pos = new ZVector(screenX(pos.x, pos.y), screenY(pos.x, pos.y));
        }
        
        float dist = pos.dist(point);
        if (dist < m_Radius * m_GameObject.GetBelongingToScene().GetScaleFactor())
            return true;

        return false;
    }


    @Override
    public ZVector GetMinExtents()
    {
        // TODO take offset into account here
        return ZVector.sub(transform().GetPosition(), new ZVector(m_Radius, m_Radius));
    }

    @Override
    public ZVector GetMaxExtents()
    {
        // TODO take offset into account here
        return ZVector.add(transform().GetPosition(), new ZVector(m_Radius, m_Radius));
    }

    /// Clamps a vector between a min and max vector
    private ZVector Clamp(ZVector value, ZVector min, ZVector max)
    {
        ZVector out = value.copy();
        out.x = Clamp(out.x, min.x, max.x);
        out.y = Clamp(out.y, min.y, max.y);
        return out;
    }
}