using Gtk;
using Singularity;
using Singularity.Widgets;

namespace Singularity.Apps {

    public class DemoWindow : Singularity.Widgets.Window {

        private Stack content_stack;
        private ListBox nav_list;

        // Groups: name -> (icon, builder delegate)
        private struct Group {
            public string name;
            public string icon;
        }

        public DemoWindow(Gtk.Application app) {
            Object(application: app);
            set_title("libsingularity Demo");
            set_default_size(1000, 680);
            toolbar.is_static = false;

            // ── Root split layout ──────────────────────────────────────────
            var root = new Box(Orientation.HORIZONTAL, 0);

            // Sidebar spacer at top so rows aren't under the floating toolbar
            var sidebar = new AppSidebar(220);
            sidebar.box.append(new ToolbarSpacer());
            nav_list = new ListBox();
            nav_list.selection_mode = SelectionMode.SINGLE;
            nav_list.add_css_class("navigation-sidebar");
            nav_list.vexpand = true;
            sidebar.box.append(nav_list);

            // Content area
            var content_area = new Box(Orientation.VERTICAL, 0);
            content_area.hexpand = true;
            content_area.vexpand = true;
            content_area.append(new ToolbarSpacer());
            content_stack = new Stack();
            content_stack.transition_type = StackTransitionType.CROSSFADE;
            content_stack.hexpand = true;
            content_stack.vexpand = true;
            content_area.append(content_stack);

            var separator = new Separator(Orientation.VERTICAL);

            root.append(sidebar);
            root.append(separator);
            root.append(content_area);

            set_content(root);

            // ── Register all widget groups ─────────────────────────────────
            add_group("Welcome",           "go-home-symbolic",                   build_welcome_page);
            add_group("Controls",          "input-mouse-symbolic",               build_controls);
            add_group("Preferences Rows",  "preferences-system-symbolic",        build_preference_rows);
            add_group("PreferencesGroup",  "view-list-symbolic",                 build_preferences_group);
            add_group("PreferencesPage",   "document-properties-symbolic",       build_preferences_page);
            add_group("PreferencesWindow", "window-new-symbolic",                build_preferences_window_demo);
            add_group("Navigation",        "go-next-symbolic",                   build_navigation);
            add_group("TabContainer",      "folder-symbolic",                    build_tab_container);
            add_group("StatusPage",        "dialog-information-symbolic",        build_status_page);
            add_group("Dialogs",           "dialog-question-symbolic",           build_dialogs);
            add_group("Visual / Charts",   "x-office-spreadsheet-symbolic",      build_visual);
            add_group("Chips",             "starred-symbolic",                   build_chips);
            add_group("HoverControls",     "media-playback-start-symbolic",      build_hover_controls);
            add_group("Context Menu",      "open-menu-symbolic",                 build_context_menu);
            add_group("Calendar Views",    "x-office-calendar-symbolic",         build_calendar);
            add_group("Toolbar",           "insert-object-symbolic",             build_toolbar_demo);
            add_group("Window",            "window-new-symbolic",                build_window_info);

            // Select first row (Welcome)
            nav_list.select_row(nav_list.get_row_at_index(0));
            nav_list.row_selected.connect((row) => {
                if (row == null) return;
                string name = row.get_data<string>("page_name");
                content_stack.visible_child_name = name;
            });
        }

        // ── Sidebar helpers ────────────────────────────────────────────────

        private delegate Widget PageBuilder();

        private void add_group(string label, string icon_name, owned PageBuilder builder) {
            string page_key = label.replace(" ", "_").replace("/", "_").down();

            // Nav row
            var row_box = new Box(Orientation.HORIZONTAL, 12);
            row_box.margin_start = 12;
            row_box.margin_end = 12;
            row_box.margin_top = 8;
            row_box.margin_bottom = 8;
            var icon = new Image.from_icon_name(icon_name);
            icon.pixel_size = 20;
            var lbl = new Label(label);
            lbl.halign = Align.START;
            lbl.hexpand = true;
            row_box.append(icon);
            row_box.append(lbl);

            var row = new ListBoxRow();
            row.set_child(row_box);
            row.set_data<string>("page_name", page_key);
            nav_list.append(row);

            content_stack.add_named(builder(), page_key);
        }

        // ── Centring wrapper ───────────────────────────────────────────────

        private Widget centered(Widget widget, int max_width = 600) {
            var scroll = new ScrolledWindow();
            scroll.hscrollbar_policy = PolicyType.NEVER;
            scroll.hexpand = true;
            scroll.vexpand = true;

            var clamp = new Box(Orientation.VERTICAL, 0);
            clamp.hexpand = true;
            clamp.vexpand = true;
            clamp.halign = Align.FILL;
            clamp.valign = Align.START;
            clamp.margin_bottom = 32;
            clamp.margin_start = 24;
            clamp.margin_end = 24;
            clamp.margin_top = 24;
            clamp.append(widget);

            scroll.set_child(clamp);
            return scroll;
        }

        private Widget section_title(string title) {
            var lbl = new Label(title);
            lbl.add_css_class("title-2");
            lbl.halign = Align.START;
            lbl.margin_bottom = 16;
            return lbl;
        }

        // ═══════════════════════════════════════════════════════════════════
        // PAGE BUILDERS
        // ═══════════════════════════════════════════════════════════════════

        // ── Controls ──────────────────────────────────────────────────────
        private Widget build_controls() {
            var box = new Box(Orientation.VERTICAL, 24);

            box.append(section_title("Controls"));

            // IconButton
            var row1 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_ib = new Label("IconButton:");
            lbl_ib.halign = Align.START;
            lbl_ib.width_chars = 18;
            row1.append(lbl_ib);
            row1.append(new IconButton("folder-symbolic"));
            box.append(row1);

            // CircularButton
            var row2 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_cb = new Label("CircularButton:");
            lbl_cb.halign = Align.START;
            lbl_cb.width_chars = 18;
            row2.append(lbl_cb);
            row2.append(new CircularButton("starred-symbolic"));
            box.append(row2);

            // CloseButton
            var row3 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_cl = new Label("CloseButton:");
            lbl_cl.halign = Align.START;
            lbl_cl.width_chars = 18;
            row3.append(lbl_cl);
            row3.append(new CloseButton());
            box.append(row3);

            // ColorPickerButton
            var row4 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_cp = new Label("ColorPickerButton:");
            lbl_cp.halign = Align.START;
            lbl_cp.width_chars = 18;
            row4.append(lbl_cp);
            var cpb = new ColorPickerButton();
            row4.append(cpb);
            box.append(row4);

            // QuickSettingTile
            var row5 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_qs = new Label("QuickSettingTile:");
            lbl_qs.halign = Align.START;
            lbl_qs.width_chars = 18;
            row5.append(lbl_qs);
            var tile = new QuickSettingTile("Wi-Fi", "network-wireless-symbolic");
            row5.append(tile);
            box.append(row5);

            // SearchEntry
            var row6 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_se = new Label("SearchEntry:");
            lbl_se.halign = Align.START;
            lbl_se.width_chars = 18;
            row6.append(lbl_se);
            var se = new Gtk.SearchEntry();
            se.placeholder_text = "Search…";
            se.hexpand = true;
            row6.append(se);
            box.append(row6);

            // SegmentedControl
            var row7 = new Box(Orientation.HORIZONTAL, 12);
            var lbl_sg = new Label("SegmentedControl:");
            lbl_sg.halign = Align.START;
            lbl_sg.width_chars = 18;
            row7.append(lbl_sg);
            var seg = new SegmentedControl();
            seg.add_option("list", "List");
            seg.add_option("grid", "Grid");
            seg.add_option("columns", "Columns");
            row7.append(seg);
            box.append(row7);

            return centered(box);
        }

        // ── Preference Rows ───────────────────────────────────────────────
        private Widget build_preference_rows() {
            var box = new Box(Orientation.VERTICAL, 8);
            box.append(section_title("Preference Rows"));

            var g = new PreferencesGroup("All Row Types");
            g.add_row(new ActionRow("ActionRow", "A simple non-interactive row", "folder-symbolic"));
            g.add_row(new SwitchRow("SwitchRow", "Toggle something on or off", true));
            g.add_row(new SpinRow("SpinRow", "Pick a number", 1, 100, 1, 42));
            g.add_row(new EntryRow("EntryRow"));
            g.add_row(new PasswordRow("PasswordRow"));
            g.add_row(new EmailRow("EmailRow"));
            var expander = new ExpanderRow("ExpanderRow", "Click to expand");
            expander.add_row(new ActionRow("Child row 1", null));
            expander.add_row(new ActionRow("Child row 2", null));
            g.add_row(expander);
            g.add_row(new SelectionRow("SelectionRow", {"Option A", "Option B", "Option C"}, "Option A"));
            var ser = new SearchableExpanderRow("SearchableExpanderRow", "Search inside");
            var ser_lbl1 = new Label("Result 1");
            ser_lbl1.margin_top = 6;
            ser_lbl1.margin_bottom = 6;
            ser.list_box.append(ser_lbl1);
            var ser_lbl2 = new Label("Result 2");
            ser_lbl2.margin_top = 6;
            ser_lbl2.margin_bottom = 6;
            ser.list_box.append(ser_lbl2);
            g.add_row(ser);
            box.append(g);

            return centered(box);
        }

        // ── PreferencesGroup ──────────────────────────────────────────────
        private Widget build_preferences_group() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("PreferencesGroup"));

            var g1 = new PreferencesGroup("Group with header suffix");
            var suffix_btn = new Button.from_icon_name("list-add-symbolic");
            suffix_btn.add_css_class("flat");
            g1.add_header_suffix(suffix_btn);
            g1.add_row(new ActionRow("Item one", "subtitle here"));
            g1.add_row(new SwitchRow("Item two", null, false));
            box.append(g1);

            var g2 = new PreferencesGroup("Group with description", "Optional subtitle below the title");
            g2.add_row(new EntryRow("Name"));
            g2.add_row(new EntryRow("Value"));
            box.append(g2);

            return centered(box);
        }

        // ── PreferencesPage ───────────────────────────────────────────────
        private Widget build_preferences_page() {
            var outer = new Box(Orientation.VERTICAL, 16);
            outer.margin_start = 24;
            outer.margin_end = 24;
            outer.margin_top = 24;
            outer.append(section_title("PreferencesPage"));

            var page = new PreferencesPage();

            var g1 = new PreferencesGroup("Section One");
            g1.add_row(new SwitchRow("Enable feature", null, true));
            g1.add_row(new SpinRow("Timeout", "Seconds before timeout", 1, 60, 1, 10));
            page.append_group(g1);

            var g2 = new PreferencesGroup("Section Two");
            g2.add_row(new SelectionRow("Mode", {"Fast", "Balanced", "Power Save"}, "Balanced"));
            g2.add_row(new EntryRow("Custom value"));
            page.append_group(g2);

            var scroll = new ScrolledWindow();
            scroll.hscrollbar_policy = PolicyType.NEVER;
            scroll.hexpand = true;
            scroll.vexpand = true;
            scroll.set_child(page);
            outer.append(scroll);
            return outer;
        }

        // ── PreferencesWindow ─────────────────────────────────────────────
        private Widget build_preferences_window_demo() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("PreferencesWindow"));

            var info = new Label("PreferencesWindow is a top-level Gtk.Window. Click the button to open it.");
            info.wrap = true;
            info.halign = Align.START;
            box.append(info);

            var btn = new Button.with_label("Open PreferencesWindow");
            btn.halign = Align.START;
            btn.add_css_class("suggested-action");
            btn.clicked.connect(() => {
                var g = new PreferencesGroup("Demo group");
                g.add_row(new SwitchRow("Option A", null, true));
                g.add_row(new EntryRow("Some setting"));
                var pg = new PreferencesPage();
                pg.append_group(g);
                var pw = new PreferencesWindow(application, pg);
                pw.present();
            });
            box.append(btn);

            return centered(box);
        }

        // ── Navigation ────────────────────────────────────────────────────
        private Widget build_navigation() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("Navigation"));

            var lbl_ssl = new Label("SidebarSectionLabel:");
            lbl_ssl.halign = Align.START;
            box.append(lbl_ssl);
            box.append(new SidebarSectionLabel("Section Header"));

            var lbl_mr = new Label("MenuRow:");
            lbl_mr.halign = Align.START;
            lbl_mr.margin_top = 12;
            box.append(lbl_mr);
            var menu_row = new MenuRow("Open folder", "folder-symbolic");
            menu_row.add_css_class("card");
            box.append(menu_row);

            return centered(box);
        }

        // ── TabContainer ──────────────────────────────────────────────────
        private Widget build_tab_container() {
            var outer = new Box(Orientation.VERTICAL, 16);
            outer.margin_start = 24;
            outer.margin_end = 24;
            outer.margin_top = 24;
            outer.append(section_title("TabContainer"));

            var tc = new TabContainer();
            tc.hexpand = true;
            tc.vexpand = true;

            var page1 = new Box(Orientation.VERTICAL, 0);
            page1.halign = Align.CENTER;
            page1.valign = Align.CENTER;
            var _w13 = new Label("Content of Tab 1") ;
            _w13.add_css_class("title-2");
            page1.append(_w13);

            var page2 = new Box(Orientation.VERTICAL, 0);
            page2.halign = Align.CENTER;
            page2.valign = Align.CENTER;
            var _w14 = new Label("Content of Tab 2") ;
            _w14.add_css_class("title-2");
            page2.append(_w14);

            var page3 = new Box(Orientation.VERTICAL, 0);
            page3.halign = Align.CENTER;
            page3.valign = Align.CENTER;
            var _w15 = new Label("Content of Tab 3") ;
            _w15.add_css_class("title-2");
            page3.append(_w15);

            tc.add_tab(page1, "Tab 1");
            tc.add_tab(page2, "Tab 2");
            tc.add_tab(page3, "Tab 3");

            outer.append(tc);
            return outer;
        }

        // ── StatusPage ────────────────────────────────────────────────────
        private Widget build_status_page() {
            var box = new Box(Orientation.VERTICAL, 24);
            box.append(section_title("StatusPage"));

            var sp = new StatusPage();
            sp.icon_name = "folder-symbolic";
            sp.title = "No Files Found";
            sp.description = "Try a different search or create a new file.";
            box.append(sp);

            return centered(box);
        }

        // ── WelcomePage ───────────────────────────────────────────────────
        private Widget build_welcome_page() {
            var wp = new WelcomePage();
            wp.app_icon_name = "dev.sinty.demo";
            wp.title = "libsingularity Demo";
            wp.subtitle = "Browse the sidebar to explore all available widgets.\nClick the actions below to see WelcomePage in action.";
            wp.hexpand = true;
            wp.vexpand = true;
            wp.add_action("document-open-symbolic", "Open Documentation", "View the full libsingularity API reference", () => {
                try {
                    AppInfo.launch_default_for_uri("https://github.com/singularityos-lab/libsingularity", null);
                } catch (Error e) {
                    warning("Could not open URL: %s", e.message);
                }
            });
            wp.add_action("insert-link-symbolic", "View Source", "Browse the demo app source code on GitHub", () => {
                try {
                    AppInfo.launch_default_for_uri("https://github.com/singularityos-lab/singularity-demo", null);
                } catch (Error e) {
                    warning("Could not open URL: %s", e.message);
                }
            });
            return wp;
        }

        // ── Dialogs ───────────────────────────────────────────────────────
        private Widget build_dialogs() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("Dialogs"));

            var info = new Label("AppDialog is a lightweight modal window. Click below to open one.");
            info.wrap = true;
            info.halign = Align.START;
            box.append(info);

            var btn = new Button.with_label("Open AppDialog");
            btn.halign = Align.START;
            btn.add_css_class("suggested-action");
            btn.clicked.connect(() => {
                var dlg = new AppDialog(application, true);
                dlg.set_title("Sample Dialog");
                dlg.transient_for = this;
                var lbl = new Label("This is an AppDialog.\nIt has a custom title bar and close button.");
                lbl.wrap = true;
                lbl.margin_top = 24;
                lbl.margin_bottom = 24;
                lbl.margin_start = 24;
                lbl.margin_end = 24;
                dlg.content_box.append(lbl);
                dlg.present();
            });
            box.append(btn);

            // ShellDialog info
            var info2 = new Label("ShellDialog is for shell-layer overlays (requires LayerShell context).");
            info2.wrap = true;
            info2.halign = Align.START;
            info2.margin_top = 12;
            box.append(info2);

            return centered(box);
        }

        // ── Visual / Charts ───────────────────────────────────────────────
        private Widget build_visual() {
            var box = new Box(Orientation.VERTICAL, 24);
            box.append(section_title("Visual / Charts"));

            // SparkLine
            var _w16 = new Label("SparkLine:") ;
            _w16.halign = Align.START;
            box.append(_w16);
            var spark = new SparkLine(30, "#5B4FD9", "#5B4FD940");
            spark.set_size_request(300, 60);
            for (int i = 0; i < 30; i++) spark.push((double)(GLib.Random.int_range(10, 90)) / 100.0);
            box.append(spark);

            // MiniBar
            var _w17 = new Label("MiniBar:") ;
            _w17.halign = Align.START;
            _w17.margin_top = 16;
            box.append(_w17);
            var bar = new MiniBar("#5B4FD9");
            bar.set_size_request(300, 40);
            bar.set_value(0.65);
            box.append(bar);

            // Chip standalone
            var _w18 = new Label("Chip:") ;
            _w18.halign = Align.START;
            _w18.margin_top = 16;
            box.append(_w18);
            var chip_row = new Box(Orientation.HORIZONTAL, 8);
            chip_row.append(new Chip("Running", "media-playback-start-symbolic"));
            chip_row.append(new Chip("Idle", null));
            chip_row.append(new Chip("Error", "dialog-error-symbolic"));
            box.append(chip_row);

            return centered(box);
        }

        // ── Chips ─────────────────────────────────────────────────────────
        private Widget build_chips() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("Chips & ChipBar"));

            var _w19 = new Label("Chip (standalone):");
            _w19.halign = Align.START;
            box.append(_w19);
            var row = new Box(Orientation.HORIZONTAL, 8);
            row.append(new Chip("Active", "emblem-ok-symbolic"));
            row.append(new Chip("Pending", "emblem-synchronizing-symbolic"));
            row.append(new Chip("Done", "emblem-default-symbolic"));
            box.append(row);

            var lbl_cb2 = new Label("ChipBar:");
            lbl_cb2.halign = Align.START;
            lbl_cb2.margin_top = 16;
            box.append(lbl_cb2);
            var cb = new ChipBar();
            cb.add_chip("alpha", "Alpha");
            cb.add_chip("beta", "Beta");
            cb.add_chip("gamma", "Gamma");
            cb.hexpand = true;
            box.append(cb);

            return centered(box);
        }

        // ── HoverControls ─────────────────────────────────────────────────
        private Widget build_hover_controls() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("HoverControls"));

            var info = new Label("HoverControls shows a toolbar overlay on mouse hover.");
            info.wrap = true;
            info.halign = Align.START;
            box.append(info);

            var hc = new HoverControls();
            hc.set_size_request(400, 200);

            // Content
            var inner = new Box(Orientation.VERTICAL, 0);
            inner.hexpand = true;
            inner.vexpand = true;
            inner.halign = Align.CENTER;
            inner.valign = Align.CENTER;
            var _w21 = new Label("Hover over me") ;
            _w21.add_css_class("title-2");
            inner.append(_w21);
            hc.set_content(inner);

            var btn1 = new Button.from_icon_name("document-edit-symbolic");
            btn1.tooltip_text = "Edit";
            hc.add_control(btn1);

            var btn2 = new Button.from_icon_name("user-trash-symbolic");
            btn2.tooltip_text = "Delete";
            hc.add_control(btn2);

            box.append(hc);

            return centered(box, 500);
        }

        // ── Context Menu ──────────────────────────────────────────────────

        // Store menus as fields to keep them alive past popup()
        private ContextMenu? _demo_ctx_menu = null;

        private Widget build_context_menu() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("ContextMenu"));

            var info = new Label("Right-click the button (or click it) to show a ContextMenu.");
            info.wrap = true;
            info.halign = Align.START;
            box.append(info);

            var btn = new Button.with_label("Show Context Menu");
            btn.halign = Align.START;
            btn.clicked.connect(() => {
                _demo_ctx_menu = new ContextMenu(btn);
                _demo_ctx_menu.add_item("New File",   "document-new-symbolic",     () => {});
                _demo_ctx_menu.add_item("Open",       "folder-open-symbolic",      () => {});
                _demo_ctx_menu.add_separator();
                _demo_ctx_menu.add_item("Delete",     "user-trash-symbolic",       () => {});
                _demo_ctx_menu.closed.connect(() => { _demo_ctx_menu.unparent(); _demo_ctx_menu = null; });
                _demo_ctx_menu.popup();
            });
            box.append(btn);

            return centered(box);
        }

        // ── Calendar Views ────────────────────────────────────────────────
        private Widget build_calendar() {
            var box = new Box(Orientation.VERTICAL, 24);
            box.append(section_title("Calendar Views"));

            var _w22 = new Label("CalendarNavPicker:") ;
            _w22.halign = Align.START;
            box.append(_w22);
            var nav = new CalendarNavPicker();
            box.append(nav);

            var _w23 = new Label("CalendarMonthView:");
            _w23.halign = Align.START;
            _w23.margin_top = 16;
            box.append(_w23);
            var lbl_no_cal = new Label("(requires CalendarManager available in shell context)");
            lbl_no_cal.halign = Align.START;
            lbl_no_cal.add_css_class("dim-label");
            box.append(lbl_no_cal);

            return centered(box, 700);
        }

        // ── Toolbar demo ──────────────────────────────────────────────────
        private Widget build_toolbar_demo() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("ToolBar"));

            var info = new Label(
                "ToolBar is used inside Singularity.Widgets.Window as the custom title bar.\n" +
                "It provides back/forward buttons, a title, and suffix widget slots.\n\n" +
                "This demo window itself uses a ToolBar look at the top.");
            info.wrap = true;
            info.halign = Align.START;
            box.append(info);

            var _w24 = new Label("ToolBar (standalone example):") ;
            _w24.halign = Align.START;
            _w24.margin_top = 12;
            box.append(_w24);
            var tb = new ToolBar();
            tb.set_title("My Page");
            tb.add_css_class("card");
            box.append(tb);

            return centered(box);
        }

        // ── Window info ───────────────────────────────────────────────────
        private Widget build_window_info() {
            var box = new Box(Orientation.VERTICAL, 16);
            box.append(section_title("Singularity.Widgets.Window"));

            var info = new Label(
                "Singularity.Widgets.Window is the base window class for all Singularity apps.\n\n" +
                "It provides:\n" +
                "  • Custom ToolBar title bar\n" +
                "  • Rounded corners (settable via GSettings)\n" +
                "  • Session state persistence (position & size)\n" +
                "  • Clamp to work area on map\n" +
                "  • set_content() + header suffix support\n\n" +
                "This window is itself a Singularity.Widgets.Window."
            );
            info.wrap = true;
            info.halign = Align.START;
            info.selectable = true;
            box.append(info);

            return centered(box);
        }
    }
}
