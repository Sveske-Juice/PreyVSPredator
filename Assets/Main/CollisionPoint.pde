// Data container/ helper struct for storing points of a collision
public class CollisionPoint
{
    public PVector A; // Furthest point of A into B
    public PVector B; // Furthest point og B into A
    public PVector Normal; // Normal vector from A to B
    public boolean HasCollision = false; // Has collided flag

    public CollisionPoint(PVector a, PVector b, PVector n, boolean hasCollision)
    {
        A = a;
        B = b;
        Normal = n;
        HasCollision = hasCollision;
    }
}