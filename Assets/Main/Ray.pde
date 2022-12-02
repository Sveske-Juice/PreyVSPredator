public class Ray
{
    /* Members. */
    private ZVector m_Origin;
    private ZVector m_Direction;

    public Ray(ZVector origin, ZVector direction)
    {
        m_Origin = origin;
        m_Direction = direction.normalize();
    }

    /* Getters/Setters. */
    public ZVector GetOrigin() { return m_Origin; }
    public ZVector GetDir() { return m_Direction; }
}