// Data container/ helper struct for storing a collision
// like which gameobjects collided, and the points of collision etc.
public class Collision
{
    public Collider ColA;
    public Collider ColB;
    public GameObject A;
    public GameObject B;
    public CollisionPoint Points;

    public Collision(Collider colA, Collider colB, GameObject a, GameObject b, CollisionPoint points)
    {
        ColA = colA;
        ColB = colB;
        A = a;
        B = b;
        Points = points;
    }
}