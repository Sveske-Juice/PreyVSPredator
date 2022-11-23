public class Ray
{
    /* Members. */
    private PVector m_Origin;
    private PVector m_Direction;

    public Ray(PVector origin, PVector direction)
    {
        m_Origin = origin;
        m_Direction = direction.normalize();
    }

    /* Getters/Setters. */
    public PVector GetOrigin() { return m_Origin; }
    public PVector GetDir() { return m_Direction; }
}