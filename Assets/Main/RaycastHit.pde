public class RaycastHit 
{
    /* Members. */
    private ZVector m_Normal; // Direction normal to the collision surface
    private ZVector m_Point; // Intersection point
    private float m_T; // Distance traveled from origin to intersection point
    private boolean m_Hit; // Hit flag

    public RaycastHit(ZVector normal, ZVector point, float t, boolean hit)
    {
        m_Normal = normal;
        m_Point = point;
        m_T = t;
        m_Hit = hit;
    }

    /* Getters/Setters. */
    public ZVector GetNormal() { return m_Normal; }
    public ZVector GetPoint() { return m_Point; }
    public float GetT() { return m_T; }
    public boolean GetHit() { return m_Hit; }
}