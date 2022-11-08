public class InputManager
{
    // Singleton pattern to access everywhere
    private static InputManager m_Instance;

    private BitField m_KeyMap = new BitField();

    public InputManager()
    {
        m_Instance = this;
    }

    public static InputManager GetInstance()
    {
        return m_Instance;
    }

    // Sets the the key to on in the keymap
    public void RegisterKey(char key)
    {
        m_KeyMap.SetBit((int) key);
    }

    // Clears the key from the key map
    public void UnregisterKey(char key)
    {
        m_KeyMap.ClearBit((int) key);
    }

    // Return true if the key is being pressed
    public boolean GetKey(char key)
    {
        return m_KeyMap.IsSet((int) key);
    }

    // Return true if the key is being pressed
    public boolean GetKey(int code)
    {
        return m_KeyMap.IsSet(code);
    }
}