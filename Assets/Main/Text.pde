// Text component which is a tiny wrapper for text() method
public class Text extends Component
{
    /* Members. */
    private String m_Text = "Insert Text here...";
    private color m_Color = color(255, 255, 255);
    private int m_HorizontalAlign = LEFT;
    private int m_VerticalAlign = TOP;
    private int m_Size = 24;
    private PVector m_Margin = new PVector();

    /* Getters/Setters. */
    public String GetText() { return m_Text; }
    public void SetText(String text) { m_Text = text; }
    public void SetHorizontalAlign(int value) { m_HorizontalAlign = value; }
    public void SetVerticalAlign(int value) { m_VerticalAlign = value; }
    public void SetMargin(PVector value) { m_Margin = value; }
    public void SetSize(int size) { m_Size = size; }
    public void SetTextColor(color newColor) { m_Color = newColor; }

    public Text()
    {
        m_Name = "Text Component";
    }

    public Text(String name)
    {
        m_Name = name;
    }

    @Override
    public void LateUpdate()
    {
        // Draw the text to the screen
        PVector pos = transform().GetPosition(); // Cache pos
        fill(m_Color);
        textAlign(m_HorizontalAlign, m_VerticalAlign);
        textSize(m_Size);
        text(m_Text, pos.x + m_Margin.x, pos.y + m_Margin.y);
        // println("Updating text element: " + m_Name + " with text: " + m_Text);
    }
}