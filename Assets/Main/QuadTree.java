import java.util.ArrayList;

public class QuadTree<T>
{
    /* Members. */
    private QuadRect m_Boundary;
    private int m_Capacity = 8; // How many points there need to be in the cell before it will be subdivided
    private ArrayList<QuadPoint<T>> m_Points = new ArrayList<QuadPoint<T>>(m_Capacity); // List of points in this cell
    private boolean m_Divided = false; // Flag specifying if this node is subdivided
    private int m_Layer = 0; // Layer in a tree this node is in
    private int m_LayerDepth = 5; // The max depth the tree can extend to - will not subdivide more

    // Children
    private QuadTree<T> m_NorthWest;
    private QuadTree<T> m_NorthEast;
    private QuadTree<T> m_SouthEast;
    private QuadTree<T> m_SouthWest;

    /* Getters/Setters. */
    public ArrayList<QuadPoint<T>> GetPoints() { return m_Points; }
    public QuadRect GetBoundary() { return m_Boundary; }
    public boolean IsDivided() { return m_Divided; }
    public QuadTree<T> GetNorthWest() { return m_NorthWest; }
    public QuadTree<T> GetNorthEast() { return m_NorthEast; }
    public QuadTree<T> GetSouthWest() { return m_SouthWest; }
    public QuadTree<T> GetSouthEast() { return m_SouthEast; }

    /* Constructors. */
    public QuadTree(QuadRect boundary, int capacity, int layer)
    {
        m_Boundary = boundary;
        m_Capacity = capacity;
        m_Layer = layer;
    }

    public QuadTree(QuadRect boundary, int capacity)
    {
        m_Boundary = boundary;
        m_Capacity = capacity;
    }

    /*  Inserts a QuadPoint<T> to the quad tree, it will handle 
        subdividing the cell if it's necesary. */
    public void Insert(QuadPoint<T> point)
    {
        // Ignore if the point to insert is not within the cell's boundary
        if (!m_Boundary.Contains(point.pos))
            return;

        // Add the point to this cell if there is room or reached max depth
        if ((m_Points.size() < m_Capacity || m_Layer >= m_LayerDepth) && !m_Divided)
        {
            m_Points.add(point);
        }
        else // If this cell is filled up
        {
            // If the cell isn't already subdivided
            if (!m_Divided)
            {
                Subdivide();
                m_Divided = true;
            }

            m_NorthWest.Insert(point);
            m_NorthEast.Insert(point);
            m_SouthWest.Insert(point);
            m_SouthEast.Insert(point);
        }
    }

    /* 
     * Subdivides this cell into four children cells - hence its called quadtree.
     * Will also move all points from this parent cell to its belonging children cells.
     */
    private void Subdivide()
    {
        float x = m_Boundary.pos.x;
        float y = m_Boundary.pos.y;
        float w = m_Boundary.size.x;
        float h = m_Boundary.size.y;

        ZVector newSize = new ZVector(w / 2f, h / 2f);

        // Calculate new positions for subdivided children
        ZVector nwPos = new ZVector(x, y);
        ZVector nePos = new ZVector(x + w / 2f, y);
        ZVector swPos = new ZVector(x, y + h / 2f);
        ZVector sePos = new ZVector(x + w / 2f, y + h / 2f);

        // Create childrens
        m_NorthWest = new QuadTree<T>(new QuadRect(nwPos, newSize), m_Capacity, m_Layer + 1);
        m_NorthEast = new QuadTree<T>(new QuadRect(nePos, newSize), m_Capacity, m_Layer + 1);
        m_SouthWest = new QuadTree<T>(new QuadRect(swPos, newSize), m_Capacity, m_Layer + 1);
        m_SouthEast = new QuadTree<T>(new QuadRect(sePos, newSize), m_Capacity, m_Layer + 1);

        // Move points over to children
        for (int i = 0; i < m_Points.size(); i++)
        {
            QuadPoint<T> point = m_Points.get(i);
            m_NorthWest.Insert(point);
            m_NorthEast.Insert(point);
            m_SouthWest.Insert(point);
            m_SouthEast.Insert(point);
        }

        m_Points.clear();
    }

    /*
     * Method for querying the tree for specific QuadPoints. It will return
     * a list of QuadPoints that are inside the range/boundary specified by "range".
     */
    public ArrayList<QuadPoint<T>> Query(QuadRect range, ArrayList<QuadPoint<T>> found)
    {
        // Return the list if the range doesn't intersect with this cell
        if (!m_Boundary.Intersects(range))
        {
            return found;
        }
        else // The range intersects with this cell
        {
            // Add the Quadpoints in this cell that also intersects with the range
            for (int i = 0; i < m_Points.size(); i++)
            {
                QuadPoint<T> point = m_Points.get(i);
                if (range.Contains(point.pos))
                {
                    found.add(point);
                }
            }
        }

        // Recursively add points from children if its subdivided
        if (m_Divided)
        {
            m_NorthWest.Query(range, found);
            m_NorthEast.Query(range, found);
            m_SouthWest.Query(range, found);
            m_SouthEast.Query(range, found);
        }

        return found;
    }

    public ArrayList<QuadPoint<T>> Query(QuadCircle range, ArrayList<QuadPoint<T>> found)
    {
        // Return the list if the range doesn't intersect with this cell
        if (!range.Intersects(m_Boundary))
        {
            return found;
        }
        else // The range intersects with this cell
        {
            // Add the Quadpoints in this cell that also intersects with the range
            for (int i = 0; i < m_Points.size(); i++)
            {
                QuadPoint<T> point = m_Points.get(i);
                if (range.Contains(point.pos))
                {
                    found.add(point);
                }
            }
        }

        // Recursively add points from children if its subdivided
        if (m_Divided)
        {
            m_NorthWest.Query(range, found);
            m_NorthEast.Query(range, found);
            m_SouthWest.Query(range, found);
            m_SouthEast.Query(range, found);
        }

        return found;
    }

    /*
     * Methods for getting all cells in the tree. Basically a list of all the leaf node's quadpoints.
     * The cells are represented by an ArrayList with the QuadPoint<T>.
     */
    public ArrayList<ArrayList<QuadPoint<T>>> GetSubCellPoints(ArrayList<ArrayList<QuadPoint<T>>> found)
    {
        // System.out.println("layer: " + m_Layer + " points in this cell: " + m_Points);
        if (m_Divided)
        {
            m_NorthWest.GetSubCellPoints(found);
            m_NorthEast.GetSubCellPoints(found);
            m_SouthWest.GetSubCellPoints(found);
            m_SouthEast.GetSubCellPoints(found);
        }
        else
        {
            if (m_Points.size() > 0)
                found.add(m_Points);
        }

        return found;
    }
}