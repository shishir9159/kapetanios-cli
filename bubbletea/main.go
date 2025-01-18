package main

import (
    "fmt"
    "os"

    tea "github.com/charmbracelet/bubbletea"
)

type model struct {
    options  []string
    cursor int
    selected map[int]struct{}   // which to-do items are selected
}

func initialModel() model {
	return model{
		options:  []string{"update", "upgrade", "certificates expiration"},
		selected: make(map[int]struct{}),
	}
}

func (m model) Init() tea.Cmd {
    // not accepting I/O at the moment
    return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
    switch msg := msg.(type) {

    // switch case for potential key press
    case tea.KeyMsg:
        switch msg.String() {  // if key is pressed
        case "ctrl+c", "q":    // exit
            return m, tea.Quit
        case "up", "k":        // vim like hot keys for navigation
            if m.cursor > 0 {
                m.cursor--
            }
        case "down", "j":
            if m.cursor < len(m.options)-1 {
                m.cursor++
            }
        case "enter", " ":     // selection
            _, ok := m.selected[m.cursor]
            if ok {
                delete(m.selected, m.cursor)
            } else {
                m.selected[m.cursor] = struct{}{}
            }
        }
    }

    // returning the updated mode for runtime reconcilation by Bubble Tea
    return m, nil
}

func (m model) View() string {
    // The header
    s := "What should we buy at the market?\n\n"

    // Iterate over our options
    for i, option := range m.options {

        // Is the cursor pointing at this option?
        cursor := " " // no cursor
        if m.cursor == i {
            cursor = ">" // cursor!
        }

        // Is this option selected?
        checked := " " // not selected
        if _, ok := m.selected[i]; ok {
            checked = "x" // selected!
        }
      
        s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, option) // Render the row
    }
  
    s += "\nPress q to quit.\n" // footer

    // Send the UI for rendering
    // view is returned for UI rendering
    return s
}

func main() {
    p := tea.NewProgram(initialModel())
    if _, err := p.Run(); err != nil {
        fmt.Printf("Alas, there's been an error: %v", err)
        os.Exit(1)
    }
}
