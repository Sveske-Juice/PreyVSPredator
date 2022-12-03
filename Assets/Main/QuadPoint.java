/* 
 * Generic class for all that the QuadTree will use to store points inserted into the tree.
 * It will have a position, and some data associated with the point of type <T>. The data
 * ex. be a collider for collision detection, so when querying the tree you can get the data.
 */
public class QuadPoint<T>
{
    public ZVector pos;
    public T pointData; // Data associated with a quad tree point (like a collider)

    public QuadPoint(ZVector _pos, T _pointData)
    {
        pos = _pos;
        pointData = _pointData;
    }

    public String toString()
    {
        return pointData.toString();
    }
}
