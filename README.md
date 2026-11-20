# Simple Task (Flutter)

This project was built as part of **SOFE4640U – Mobile Application Development (Lab 5)**. It re-implements the SimpleTask app in Flutter using in-memory state.

## How Lab Requirements Were Met

- **Home Screen:** Built with a custom app bar, an empty-state screen (`No tasks here.` with a local asset image), and a `ListView.builder` that renders each task card in its chosen colour alongside its title and deadline.
- **New Task Screen:** Includes a title field, multi-line description field, `showDatePicker` deadline selector, and 4 colour swatches inside a `SingleChildScrollView` so fields remain visible when the keyboard opens. Tapping **Done** validates that the title is non-empty before returning the new task to the Home screen, while the back arrow cancels without adding anything.
- **Task Deletion:** Long-pressing any task tile opens a confirmation `AlertDialog` that removes the task on **Delete** or keeps it on **Cancel**.
- **Custom Styling:** Replaced Flutter's default theme with a consistent Deep Teal and Warm Amber colour scheme, paired with the custom `SFCompact` font, pill-shaped buttons, and rounded input borders.
