using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Odbc;

namespace Logbook_System
{
    public partial class frmLogin : Form
    {
        public frmLogin()
        {
            InitializeComponent();
        }
        private void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Check
            if (System.Text.RegularExpressions.Regex.IsMatch(password, @"[^a-zA-Z0-9]"))
            {
                MessageBox.Show("Password must not contain special characters.", "Invalid Password", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtPassword.Clear();
                return; // stop
            }
            try
            {
                using (OdbcConnection conn = DBConnection.GetConnection())
                {
                    conn.Open();

                    string query = "SELECT * FROM tbl_users WHERE username=? AND password=?";
                    OdbcCommand cmd = new OdbcCommand(query, conn);
                    cmd.Parameters.AddWithValue("@username", txtUsername.Text);
                    cmd.Parameters.AddWithValue("@password", txtPassword.Text);

                    OdbcDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        string role = dr["role"].ToString();
                        MessageBox.Show("Login successful!", "Access Granted", MessageBoxButtons.OK, MessageBoxIcon.Information);

                        frmDashboard dashboard = new frmDashboard();
                        dashboard.Show();
                        this.Hide();
                    }
                    else
                    {
                        MessageBox.Show("Invalid username or password.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        txtPassword.Clear();
                        txtUsername.Focus();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Database connection failed: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void cbCheckpass_CheckedChanged(object sender, EventArgs e)
        {
            if (cbCheckpass.Checked)
                txtPassword.PasswordChar = '\0'; // show
            else
                txtPassword.PasswordChar = '*'; // hide
        }
    }
}

