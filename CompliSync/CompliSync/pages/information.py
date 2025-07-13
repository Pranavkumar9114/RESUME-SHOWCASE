import flet as ft
import json
import os

# Global variable to cache data and avoid reloading every time
cached_policies = None
dest_path = None

def load_policies():
    global cached_policies

    if cached_policies is not None:
        return cached_policies

    if not os.path.exists(dest_path):
        return {"error": "Please upload or fetch CIS PDF file in Audit Page to get information."}

    try:
        with open(dest_path, "r", encoding="utf-8") as file:
            policies_data = json.load(file)

            # Ensure policies_data is a list
            if isinstance(policies_data, dict):  
                policies_data = [policies_data]  # Convert to list if it's a single dict
            elif not isinstance(policies_data, list):  
                return {"error": "Invalid JSON format in policy file."}

            cached_policies = policies_data  # Cache the policies
            return cached_policies

    except json.JSONDecodeError as e:
        return {"error": f"Error parsing JSON file! {e}"}

def information(page: ft.Page):
    global dest_path
    dest_path = page.client_storage.get("json_dest_path")
    policies = load_policies()

    if isinstance(policies, dict) and "error" in policies:
        return ft.Text(policies["error"], size=24, weight=ft.FontWeight.BOLD, color=ft.colors.RED)

    # Track which policy is expanded
    expanded_policies = {policy["policy_id"]: False for policy in policies}

    # Search functionality
    def search_policies(query):
        """Filter policies based on the search query."""
        query = query.strip().lower()
        return [policy for policy in policies
                if query in policy.get("title", "").lower() or query in str(policy.get("policy_id", "")).lower()
                ]

    def toggle_policy_visibility(policy_id):
        """Toggle the expanded state for a specific policy."""
        expanded_policies[policy_id] = not expanded_policies[policy_id]
        policy_column.controls.clear()
        # Render all policies immediately
        policy_column.controls.extend(render_policies(filtered_policies))
        page.update()

    def render_policies(policy_list):
        """Render policies into widgets."""
        widgets = []
        for policy in policy_list:
            policy_id = policy.get("policy_id", "N/A")

            widgets.append(
                ft.Text(f"Policy ID: {policy_id}", size=20, weight=ft.FontWeight.BOLD))
            widgets.append(ft.Text(
                f"Title: {policy.get('title', 'N/A')}", size=16, weight=ft.FontWeight.BOLD))

            if expanded_policies.get(policy_id, False):
                # Show full details when expanded
                for key in ["description", "rationale", "impact", "audit", "remediation", "default_value"]:
                    if key in policy:
                        widgets.append(ft.Text(
                            f"\n{key.replace('_', ' ').title()}:", size=16, weight=ft.FontWeight.BOLD))
                        widgets.append(ft.Container(
                            content=ft.Text(
                                policy[key],
                                size=16, weight=ft.FontWeight.NORMAL, selectable=True),
                            padding=ft.padding.all(10),
                            # bgcolor=ft.colors.GREY_100,
                            border_radius=ft.border_radius.all(5),
                        ))

            # Toggle button for "Show More" or "Show Less"
            button_text = "Show Less" if expanded_policies.get(
                policy_id, False) else "Show More"
            widgets.append(ft.ElevatedButton(
                button_text, on_click=lambda e, p_id=policy_id: toggle_policy_visibility(p_id)))

            widgets.append(ft.Divider(thickness=2))

        return widgets

    # Determine the background color based on the theme mode (light or dark)
    container_bgcolor = ft.colors.WHITE if page.theme_mode == ft.ThemeMode.LIGHT else ft.colors.GREY_900

    # Initialize policy column to render all policies at once
    filtered_policies = policies  # Start with all policies
    policy_column = ft.Column(render_policies(filtered_policies))

    scrollable_container = ft.Container(
        content=ft.Column(
            [policy_column], 
            scroll=ft.ScrollMode.AUTO, 
            expand=True  # Allow the container to expand fully
        ),
        expand=True,  # Expand to fit available space
        bgcolor=container_bgcolor,  # Use the determined background color
        padding=ft.padding.all(10),
        border_radius=ft.border_radius.all(10),
    )

    # Create the title and search bar on top
    title = ft.Text("Information", size=32,
                    weight=ft.FontWeight.BOLD)

    search_box = ft.TextField(
        label="Search Policies",
        # When search text changes, filter policies
        on_change=lambda e: update_search_policies(e.control.value)
    )

    # Function to update the policies displayed based on the search query
    def update_search_policies(query):
        nonlocal filtered_policies
        filtered_policies = search_policies(query)  # Filter based on query
        policy_column.controls.clear()
        policy_column.controls.extend(render_policies(filtered_policies))
        page.update()

    return ft.Container(
        ft.Column([
            title,  # Title
            search_box,  # Search bar
            scrollable_container  # Policies list
            ], 
            expand=True, 
            alignment=ft.alignment.top_left
        ),
        padding=20,
        expand=True,
    )
