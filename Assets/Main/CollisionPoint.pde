// Data container/ helper struct for storing points of a collision
public class CollisionPoint
{
    public PVector A;
    public PVector B;
    public PVector Normal;
    public boolean HasCollision = false;

    public CollisionPoint(PVector a, PVector b, PVector n, boolean hasCollision)
    {
        A = a;
        B = b;
        Normal = n;
        HasCollision = hasCollision;
    }
}