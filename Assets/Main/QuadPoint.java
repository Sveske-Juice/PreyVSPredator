public class QuadPoint<T>
{
    public ZVector pos;
    public T pointData; // Data associated with a quad tree point (like a collider)

    public QuadPoint(ZVector _pos, T _pointData)
    {
        pos = _pos;
        pointData = _pointData;
    }
}
