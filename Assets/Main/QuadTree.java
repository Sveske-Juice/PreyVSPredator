import java.util.ArrayList;

public class QuadTree<T>
{
    /* Members. */
    private QuadRect m_Boundary;
    private int m_Capacity = 5;
    private ArrayList<QuadPoint<T>> m_Points = new ArrayList<QuadPoint<T>>();
    private boolean m_Divided = false;

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

    public QuadTree(QuadRect boundary, int capacity)
    {
        m_Boundary = boundary;
        m_Capacity = capacity;
    }

    public void InsertEntity(QuadPoint point)
    {  
        IQuadTreeEntity quadEntity = (IQuadTreeEntity) entity; // Cast entity to interface
        ZVector pos = quadEntity.GetPosition();

        // Check if entity can be in this cell
        if (!(  pos.x > m_Boundary.x && pos.x < m_Boundary.x + m_Size.x &&
                pos.y > m_Boundary.y && pos.y < m_Boundary.y + m_Size.y))
        {
            System.out.println("entity cant be in this cell");
            System.out.println("collider pos: " + pos);
            System.out.println("boundary: " + m_Boundary);
            return;
        }

        if (m_Entities.size() < m_Capacity)
            m_Entities.add(entity);
        else
        {
            if (!m_Divided)
            {
                subdivide();
            }
            
            // Capacity reached, insert to child cells   
            m_NorthEast.InsertEntity(entity);
            m_NorthWest.InsertEntity(entity);
            m_SouthEast.InsertEntity(entity);
            m_SouthWest.InsertEntity(entity);
        }


    }

    private void subdivide()
    {
        System.out.println("subdividing");
        
        float x = m_Boundary.x;
        float y = m_Boundary.y;
        float w = m_Size.x;
        float h = m_Size.y;

        ZVector newSize = new ZVector(w / 2f, h / 2f);
        
        // Calculate new positions for subdivided children
        ZVector nwPos = new ZVector(x, y);
        ZVector nePos = new ZVector(x + w, y);
        ZVector swPos = new ZVector(x, y + h);
        ZVector sePos = new ZVector(x + w, y + h);
        
        // Create subdivided children
        m_NorthWest = new QuadTree<T>(nwPos, newSize, m_Capacity);
        m_NorthEast = new QuadTree<T>(nePos, newSize, m_Capacity);
        m_SouthWest = new QuadTree<T>(swPos, newSize, m_Capacity);
        m_SouthEast = new QuadTree<T>(sePos, newSize, m_Capacity);
        m_Divided = true;
    }

    public ArrayList<ArrayList<T>> GetAllEntities()
    {
        ArrayList<ArrayList<T>> out = new ArrayList<ArrayList<T>>(1);

        // This tree's entities
        out.add(m_Entities);

        // Recursively traverse children and add to out
        GetEntitesRecursively(out);

        return out;
    }

    public void GetEntitesRecursively(ArrayList<ArrayList<T>> out)
    {
        if (m_Divided)
        {
            m_NorthEast.GetEntitesRecursively(out);
            m_NorthWest.GetEntitesRecursively(out);
            m_SouthEast.GetEntitesRecursively(out);
            m_SouthWest.GetEntitesRecursively(out);
        }
        else
        {
            out.add(m_Entities);
        }
    }
}