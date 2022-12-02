// Data container/ helper struct for storing points of a collision
public class CollisionPoint
{
    public ZVector A; // Furthest point of A into B
    public ZVector B; // Furthest point og B into A
    public ZVector Normal; // Normal vector from A to B
    public boolean HasCollision = false; // Has collided flag

    public CollisionPoint(ZVector a, ZVector b, ZVector n, boolean hasCollision)
    {
        A = a;
        B = b;
        Normal = n;
        HasCollision = hasCollision;
    }
}