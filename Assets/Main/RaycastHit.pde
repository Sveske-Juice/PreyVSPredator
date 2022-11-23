public class RaycastHit 
{
    /* Members. */
    private PVector m_Normal; // Direction normal to the collision surface
    private PVector m_Point; // Intersection point
    private float m_T; // Distance traveled from origin to intersection point
    private boolean m_Hit; // Hit flag

    public RaycastHit(PVector normal, PVector point, float t, boolean hit)
    {
        m_Normal = normal;
        m_Point = point;
        m_T = t;
        m_Hit = hit;
    }

    /* Getters/Setters. */
    public PVector GetNormal() { return m_Normal; }
    public PVector GetPoint() { return m_Point; }
    public float GetT() { return m_T; }
    public boolean GetHit() { return m_Hit; }
}