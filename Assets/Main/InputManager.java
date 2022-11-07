public class InputManager
{
    private static InputManager m_Instance = new InputManager();

    private BitField m_KeyMap = new BitField();

    public InputManager()
    {
        m_Instance = this;
    }

    public static InputManager GetInstance()
    {
        return m_Instance;
    }

    public void RegisterKey(char key)
    {
        
        m_KeyMap.SetBit((int) key);
    }

    public void UnregisterKey(char key)
    {
        m_KeyMap.ClearBit((int) key);
    }

    public boolean GetKey(char key)
    {
        return m_KeyMap.IsSet((int) key);
    }

    public boolean GetKey(int code)
    {
        return m_KeyMap.IsSet(code);
    }
}