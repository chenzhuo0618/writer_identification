package writerui;

import java.awt.AWTException;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.Robot;

import javax.imageio.ImageIO;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EmptyBorder;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.border.LineBorder;

import java.awt.Color;

import javax.swing.JLabel;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;

import javax.swing.UIManager;

import com.mathworks.toolbox.javabuilder.*;

import MatlabJet.*;

/**
 * This code was edited or generated using CloudGarden's Jigloo SWT/Swing GUI
 * Builder, which is free for non-commercial use. If Jigloo is being used
 * commercially (ie, by a corporation, company or business for any purpose
 * whatever) then you should purchase a license for each developer using Jigloo.
 * Please visit www.cloudgarden.com for details. Use of Jigloo implies
 * acceptance of these licensing terms. A COMMERCIAL LICENSE HAS NOT BEEN
 * PURCHASED FOR THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED LEGALLY FOR
 * ANY CORPORATE OR COMMERCIAL PURPOSE.
 */
public class writer extends JFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JPanel panel_extract;
	private int count = 0;
	writer frm = this;
	int drag_status = 0, c1, c2, c3, c4;
	BufferedImage image;
	int a, b, c, d;
	BufferedImage IM;
	private JLabel Label_origin;
	Object[] person = null;
	private JLabel label_extract;
	private String path_to_db;
	private String testimg;

	//
	private ImageIcon scaleImage(int a, int b, ImageIcon icon) {

		Image image = icon.getImage();
		image = image.getScaledInstance(a, b, Image.SCALE_DEFAULT);
		return new ImageIcon(image);
	}

	/**
	 * Launch the application.
	 */
	//
	public static void main(String[] args) throws MWException {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					writer frame = new writer();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public writer() {
		setResizable(false);
		setTitle("\u5B9E\u9A8C");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(0, 0, 1140, 660);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(new BorderLayout(0, 0));
		setContentPane(contentPane);

		JPanel panel_mainmenu = new JPanel();
		panel_mainmenu.setBorder(new LineBorder(new Color(0, 0, 0)));
		panel_mainmenu.setPreferredSize(new java.awt.Dimension(1124, 36));
		contentPane.add(panel_mainmenu, BorderLayout.NORTH);
		panel_mainmenu.setLayout(null);

		Label_origin = new JLabel("");
		Label_origin.setBackground(Color.WHITE);

		// btn_load_trainset
		JButton btn_load_trainset = new JButton(
				"\u52A0\u8F7D\u6570\u636E\u96C6");
		btn_load_trainset.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser("e:\\");
				fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				int returnVal = fileChooser.showOpenDialog(fileChooser);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					String filePath = fileChooser.getSelectedFile()
							.getAbsolutePath();
					path_to_db = filePath;
					JOptionPane.showMessageDialog(null, "加载训练数据集成功!");
				}
			}
		});
		btn_load_trainset.setBounds(189, 6, 100, 23);
		panel_mainmenu.add(btn_load_trainset);

		JButton btn_train = new JButton("\u8BAD\u7EC3");
		btn_train.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				JOptionPane.showMessageDialog(null, "");
				String modelfile = "modelfile";
				MatlabJet matlab_jet = null;
				try {
					matlab_jet = new MatlabJet();
				} catch (MWException e) 
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				MWNumericArray train_length = new MWNumericArray(Double
						.valueOf(9), MWClassID.DOUBLE);
				try {
					matlab_jet.train_writers(1, path_to_db, train_length,
							modelfile);
				} catch (MWException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				JOptionPane.showMessageDialog(null, "");
			}
		});
		btn_train.setBounds(442, 6, 100, 23);
		panel_mainmenu.add(btn_train);

		final JButton btn_select_test = new JButton("\u9009\u62E9\u6837\u672C");
		btn_select_test.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser("");
				int returnVal = fileChooser.showOpenDialog(fileChooser);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					String f = fileChooser.getSelectedFile().getAbsolutePath();
					testimg = f;
					ImageIcon icon = new ImageIcon(f, "");
					Label_origin.setIcon(icon);
				}
			}
		});
		btn_select_test.setBounds(593, 6, 115, 23);
		btn_select_test.setText("\u9009\u62e9\u6d4b\u8bd5\u56fe\u7247 ");
		panel_mainmenu.add(btn_select_test);

		JButton btn_test = new JButton(
				"\u6D4B\u8BD5\u9009\u53D6\u7684\u56FE\u7247");
		btn_test.setBounds(814, 7, 98, 22);
		btn_test.setText("\u6d4b\u8bd5");
		btn_test.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String modelfile = "modelfile";
				MatlabJet matlab_jet = null;
				try {
					matlab_jet = new MatlabJet();
				} catch (MWException e2) {
					// TODO Auto-generated catch block
					e2.printStackTrace();
				}
				MWNumericArray train_length = new MWNumericArray(Double
						.valueOf(9), MWClassID.DOUBLE);
				try {
					person = matlab_jet.test_writer(1, modelfile, train_length,
							testimg);
				} catch (MWException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				// System.out.println(person[0]);
				/*
				 * JFrame ss =new JFrame("what"); ss.setVisible(true);
				 * ss.setSize(400, 400); JLabel label1 = new JLabel();
				 * label1.setText((String) person[0]);
				 * ss.getContentPane().add(label1);
				 */
				JOptionPane.showMessageDialog(null, "the writer is" + person[0]
						+ " writes");
			}
		});
		panel_mainmenu.add(btn_test);


		JPanel panel_origin = new JPanel();
		panel_origin.setVerifyInputWhenFocusTarget(false);
		panel_origin.setBorder(new LineBorder(new Color(0, 0, 0)));
		panel_origin.setPreferredSize(new Dimension(500, 0));
		contentPane.add(panel_origin, BorderLayout.WEST);
		panel_origin.setLayout(null);

		JLabel label_origin = new JLabel(
				"\u9700\u8981\u6D4B\u8BD5\u7684\u56FE\u7247");
		label_origin.setBounds(203, 7, 100, 15);
		label_origin.setText("\u539f\u59cb\u56fe\u7247");
		panel_origin.add(label_origin);

		JScrollPane scrollPane = new JScrollPane(Label_origin);
		scrollPane.setBounds(10, 33, 480, 500);
		panel_origin.add(scrollPane);

		Label_origin.addMouseListener(new MouseListener() {
			@Override
			public void mouseClicked(MouseEvent e) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mousePressed(MouseEvent e) {
				// TODO Auto-generated method stub
				if (e.getSource() == Label_origin) {
					c1 = e.getXOnScreen();
					c2 = e.getYOnScreen();
				}
			}

			@Override
			public void mouseReleased(MouseEvent e) {
				// TODO Auto-generated method stub
				if (drag_status == 1) {
					c3 = e.getXOnScreen();
					c4 = e.getYOnScreen();
					try {
						int w = c3 - c1;
						int h = c4 - c2;
						// w = w * -1;
						// h = h * -1;
						Robot robot = new Robot();
						if (w > 0 && h > 0) {
							image = robot.createScreenCapture(new Rectangle(c1,
									c2, w, h));
						}
					} catch (Exception exception) {
						exception.printStackTrace();
					}
				}

			}

			@Override
			public void mouseEntered(MouseEvent e) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseExited(MouseEvent e) {
				// TODO Auto-generated method stub

			}
		});
		Label_origin.addMouseMotionListener(new MouseMotionListener() {
			public void mouseDragged(MouseEvent arg0) {
				repaint();
				drag_status = 1;
				c3 = arg0.getXOnScreen();
				c4 = arg0.getYOnScreen();
				Graphics g = getGraphics();
				g.setColor(Color.BLUE);
				g.drawRect(c1, c2, c3 - c1, c4 - c2);
			}

			public void mouseMoved(MouseEvent arg0) {
				Graphics g = getGraphics();
				g.setColor(Color.BLUE);
				g.drawRect(c1, c2, c3 - c1, c4 - c2);

			}
		});

		JPanel panel_pre_menu = new JPanel();
		panel_pre_menu.setToolTipText("");
		panel_pre_menu.setLayout(null);
		contentPane.add(panel_pre_menu, BorderLayout.CENTER);


		JButton btn_cancel = new JButton("\u53D6\u6D88");
		btn_cancel.setBounds(16, 257, 93, 23);
		panel_pre_menu.add(btn_cancel);

		panel_extract = new JPanel();
		panel_extract.setBorder(new LineBorder(new Color(0, 0, 0)));
		panel_extract.setPreferredSize(new java.awt.Dimension(500, 558));
		panel_extract.setLayout(null);
		contentPane.add(panel_extract, BorderLayout.EAST);

		final JLabel label_1 = new JLabel("");
		label_1.setForeground(UIManager.getColor("Button.disabledShadow"));
		label_1.setBounds(10, 30, 60, 60);
		panel_extract.add(label_1);

		final JLabel label_2 = new JLabel("");
		label_2.setBounds(70, 30, 60, 60);
		panel_extract.add(label_2);

		final JLabel label_3 = new JLabel("");
		label_3.setBounds(130, 30, 60, 60);
		panel_extract.add(label_3);

		final JLabel label_4 = new JLabel("");
		label_4.setBounds(190, 30, 60, 60);
		panel_extract.add(label_4);

		final JLabel label_5 = new JLabel("");
		label_5.setBounds(250, 30, 60, 60);
		panel_extract.add(label_5);

		final JLabel label_6 = new JLabel("");
		label_6.setBounds(310, 30, 60, 60);
		panel_extract.add(label_6);

		final JLabel label_7 = new JLabel("");
		label_7.setBounds(370, 30, 60, 60);
		panel_extract.add(label_7);

		final JLabel label_8 = new JLabel("");
		label_8.setBounds(430, 30, 60, 60);
		panel_extract.add(label_8);

		final JLabel label_9 = new JLabel("");
		label_9.setBounds(10, 90, 60, 60);
		panel_extract.add(label_9);

		final JLabel label_10 = new JLabel("");
		label_10.setBounds(70, 90, 60, 60);
		panel_extract.add(label_10);

		final JLabel label_11 = new JLabel("");
		label_11.setBounds(130, 90, 60, 60);
		panel_extract.add(label_11);

		final JLabel label_12 = new JLabel("");
		label_12.setBounds(190, 90, 60, 60);
		panel_extract.add(label_12);

		final JLabel label_13 = new JLabel("");
		label_13.setBounds(250, 90, 60, 60);
		panel_extract.add(label_13);

		final JLabel label_14 = new JLabel("");
		label_14.setBounds(310, 90, 60, 60);
		panel_extract.add(label_14);

		final JLabel label_15 = new JLabel("");
		label_15.setBounds(370, 90, 60, 60);
		panel_extract.add(label_15);

		final JLabel label_16 = new JLabel("");
		label_16.setBounds(430, 90, 60, 60);
		panel_extract.add(label_16);

		final JLabel label_17 = new JLabel("");
		label_17.setBounds(10, 150, 60, 60);
		panel_extract.add(label_17);

		final JLabel label_18 = new JLabel("");
		label_18.setBounds(70, 150, 60, 60);
		panel_extract.add(label_18);

		final JLabel label_19 = new JLabel("");
		label_19.setBounds(130, 150, 60, 60);
		panel_extract.add(label_19);

		final JLabel label_20 = new JLabel("");
		label_20.setBounds(190, 150, 60, 60);
		panel_extract.add(label_20);

		final JLabel label_21 = new JLabel("");
		label_21.setBounds(250, 150, 60, 60);
		panel_extract.add(label_21);

		final JLabel label_22 = new JLabel("");
		label_22.setBounds(310, 150, 60, 60);
		panel_extract.add(label_22);

		final JLabel label_23 = new JLabel("");
		label_23.setBounds(370, 150, 60, 60);
		panel_extract.add(label_23);

		final JLabel label_24 = new JLabel("");
		label_24.setBounds(430, 150, 60, 60);
		panel_extract.add(label_24);

		final JLabel label_25 = new JLabel("");
		label_25.setBounds(10, 210, 60, 60);
		panel_extract.add(label_25);

		final JLabel label_26 = new JLabel("");
		label_26.setBounds(70, 210, 60, 60);
		panel_extract.add(label_26);

		final JLabel label_27 = new JLabel("");
		label_27.setBounds(130, 210, 60, 60);
		panel_extract.add(label_27);

		final JLabel label_28 = new JLabel("");
		label_28.setBounds(190, 210, 60, 60);
		panel_extract.add(label_28);

		final JLabel label_29 = new JLabel("");
		label_29.setBounds(250, 210, 60, 60);
		panel_extract.add(label_29);

		final JLabel label_30 = new JLabel("");
		label_30.setBounds(310, 210, 60, 60);
		panel_extract.add(label_30);

		final JLabel label_31 = new JLabel("");
		label_31.setBounds(370, 210, 60, 60);
		panel_extract.add(label_31);

		final JLabel label_32 = new JLabel("");
		label_32.setBounds(430, 210, 60, 60);
		panel_extract.add(label_32);

		final JLabel label_33 = new JLabel("");
		label_33.setBounds(10, 270, 60, 60);
		panel_extract.add(label_33);

		final JLabel label_34 = new JLabel("");
		label_34.setBounds(70, 270, 60, 60);
		panel_extract.add(label_34);

		final JLabel label_35 = new JLabel("");
		label_35.setBounds(130, 270, 60, 60);
		panel_extract.add(label_35);

		final JLabel label_36 = new JLabel("");
		label_36.setBounds(190, 270, 60, 60);
		panel_extract.add(label_36);

		final JLabel label_37 = new JLabel("");
		label_37.setBounds(250, 270, 60, 60);
		panel_extract.add(label_37);

		final JLabel label_38 = new JLabel("");
		label_38.setBounds(310, 270, 60, 60);
		panel_extract.add(label_38);

		final JLabel label_39 = new JLabel("");
		label_39.setBounds(370, 270, 60, 60);
		panel_extract.add(label_39);

		final JLabel label_40 = new JLabel("");
		label_40.setBounds(430, 270, 60, 60);
		panel_extract.add(label_40);

		final JLabel label_41 = new JLabel("");
		label_41.setBounds(10, 330, 60, 60);
		panel_extract.add(label_41);

		final JLabel label_42 = new JLabel("");
		label_42.setBounds(70, 330, 60, 60);
		panel_extract.add(label_42);

		final JLabel label_43 = new JLabel("");
		label_43.setBounds(130, 330, 60, 60);
		panel_extract.add(label_43);

		final JLabel label_44 = new JLabel("");
		label_44.setBounds(190, 330, 60, 60);
		panel_extract.add(label_44);

		final JLabel label_45 = new JLabel("");
		label_45.setBounds(250, 330, 60, 60);
		panel_extract.add(label_45);

		final JLabel label_46 = new JLabel("");
		label_46.setBounds(310, 330, 60, 60);
		panel_extract.add(label_46);

		final JLabel label_47 = new JLabel("");
		label_47.setBounds(370, 330, 60, 60);
		panel_extract.add(label_47);

		final JLabel label_48 = new JLabel("");
		label_48.setBounds(430, 330, 60, 60);
		panel_extract.add(label_48);

		final JLabel label_49 = new JLabel("");
		label_49.setBounds(10, 390, 60, 60);
		panel_extract.add(label_49);

		final JLabel label_50 = new JLabel("");
		label_50.setBounds(70, 390, 60, 60);
		panel_extract.add(label_50);

		final JLabel label_51 = new JLabel("");
		label_51.setBounds(130, 390, 60, 60);
		panel_extract.add(label_51);

		final JLabel label_52 = new JLabel("");
		label_52.setBounds(190, 390, 60, 60);
		panel_extract.add(label_52);

		final JLabel label_53 = new JLabel("");
		label_53.setBounds(250, 390, 60, 60);
		panel_extract.add(label_53);

		final JLabel label_54 = new JLabel("");
		label_54.setBounds(310, 390, 60, 60);
		panel_extract.add(label_54);

		final JLabel label_55 = new JLabel("");
		label_55.setBounds(370, 390, 60, 60);
		panel_extract.add(label_55);

		final JLabel label_56 = new JLabel("");
		label_56.setBounds(430, 390, 60, 60);
		panel_extract.add(label_56);

		final JLabel label_57 = new JLabel("");
		label_57.setBounds(10, 450, 60, 60);
		panel_extract.add(label_57);

		final JLabel label_58 = new JLabel("");
		label_58.setBounds(70, 450, 60, 60);
		panel_extract.add(label_58);

		final JLabel label_59 = new JLabel("");
		label_59.setBounds(130, 450, 60, 60);
		panel_extract.add(label_59);

		final JLabel label_60 = new JLabel("");
		label_60.setBounds(190, 450, 60, 60);
		panel_extract.add(label_60);

		final JLabel label_61 = new JLabel("");
		label_61.setBounds(250, 450, 60, 60);
		panel_extract.add(label_61);

		final JLabel label_62 = new JLabel("");
		label_62.setBounds(310, 450, 60, 60);
		panel_extract.add(label_62);

		final JLabel label_63 = new JLabel("");
		label_63.setBounds(370, 450, 60, 60);
		panel_extract.add(label_63);

		final JLabel label_64 = new JLabel("");
		label_64.setBounds(430, 450, 60, 60);
		panel_extract.add(label_64);
		{
			label_extract = new JLabel();
			panel_extract.add(label_extract);
			label_extract.setText("\u63d0\u53d6\u540e\u7684\u56fe\u7247");
			label_extract.setBounds(202, 7, 90, 17);
		}

		final JButton btn_extract = new JButton("\u63D0\u53D6");
		// btnNewButton_4
		btn_extract.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// if (true)
				// {
				// return;
				// }
				ImageIcon icon = new ImageIcon(image);
				//
				count++;
				if (count == 1) {
					label_1.setIcon(scaleImage(60, 60, icon));
				} else if (count == 2) {
					label_2.setIcon(scaleImage(60, 60, icon));
				} else if (count == 3) {
					label_3.setIcon(scaleImage(60, 60, icon));
				} else if (count == 4) {
					label_4.setIcon(scaleImage(60, 60, icon));
				} else if (count == 5) {
					label_5.setIcon(scaleImage(60, 60, icon));
				} else if (count == 6) {
					label_6.setIcon(scaleImage(60, 60, icon));
				} else if (count == 7) {
					label_7.setIcon(scaleImage(60, 60, icon));
				} else if (count == 8) {
					label_8.setIcon(scaleImage(60, 60, icon));
				} else if (count == 9) {
					label_9.setIcon(scaleImage(60, 60, icon));
				} else if (count == 10) {
					label_10.setIcon(scaleImage(60, 60, icon));
				} else if (count == 11) {
					label_11.setIcon(scaleImage(60, 60, icon));
				} else if (count == 12) {
					label_12.setIcon(scaleImage(60, 60, icon));
				} else if (count == 13) {
					label_13.setIcon(scaleImage(60, 60, icon));
				} else if (count == 14) {
					label_14.setIcon(scaleImage(60, 60, icon));
				} else if (count == 15) {
					label_15.setIcon(scaleImage(60, 60, icon));
				} else if (count == 16) {
					label_16.setIcon(scaleImage(60, 60, icon));
				} else if (count == 17) {
					label_17.setIcon(scaleImage(60, 60, icon));
				} else if (count == 18) {
					label_18.setIcon(scaleImage(60, 60, icon));
				} else if (count == 19) {
					label_19.setIcon(scaleImage(60, 60, icon));
				} else if (count == 20) {
					label_20.setIcon(scaleImage(60, 60, icon));
				} else if (count == 21) {
					label_21.setIcon(scaleImage(60, 60, icon));
				} else if (count == 22) {
					label_22.setIcon(scaleImage(60, 60, icon));
				} else if (count == 23) {
					label_23.setIcon(scaleImage(60, 60, icon));
				} else if (count == 24) {
					label_24.setIcon(scaleImage(60, 60, icon));
				} else if (count == 25) {
					label_25.setIcon(scaleImage(60, 60, icon));
				} else if (count == 26) {
					label_26.setIcon(scaleImage(60, 60, icon));
				} else if (count == 27) {
					label_27.setIcon(scaleImage(60, 60, icon));
				} else if (count == 28) {
					label_28.setIcon(scaleImage(60, 60, icon));
				} else if (count == 29) {
					label_29.setIcon(scaleImage(60, 60, icon));
				} else if (count == 30) {
					label_30.setIcon(scaleImage(60, 60, icon));
				} else if (count == 31) {
					label_31.setIcon(scaleImage(60, 60, icon));
				} else if (count == 32) {
					label_32.setIcon(scaleImage(60, 60, icon));
				} else if (count == 33) {
					label_33.setIcon(scaleImage(60, 60, icon));
				} else if (count == 34) {
					label_34.setIcon(scaleImage(60, 60, icon));
				} else if (count == 35) {
					label_35.setIcon(scaleImage(60, 60, icon));
				} else if (count == 36) {
					label_36.setIcon(scaleImage(60, 60, icon));
				} else if (count == 37) {
					label_37.setIcon(scaleImage(60, 60, icon));
				} else if (count == 38) {
					label_38.setIcon(scaleImage(60, 60, icon));
				} else if (count == 39) {
					label_39.setIcon(scaleImage(60, 60, icon));
				} else if (count == 40) {
					label_40.setIcon(scaleImage(60, 60, icon));
				} else if (count == 41) {
					label_41.setIcon(scaleImage(60, 60, icon));
				} else if (count == 42) {
					label_42.setIcon(scaleImage(60, 60, icon));
				} else if (count == 43) {
					label_43.setIcon(scaleImage(60, 60, icon));
				} else if (count == 44) {
					label_44.setIcon(scaleImage(60, 60, icon));
				} else if (count == 45) {
					label_45.setIcon(scaleImage(60, 60, icon));
				} else if (count == 46) {
					label_46.setIcon(scaleImage(60, 60, icon));
				} else if (count == 47) {
					label_47.setIcon(scaleImage(60, 60, icon));
				} else if (count == 48) {
					label_48.setIcon(scaleImage(60, 60, icon));
				} else if (count == 49) {
					label_49.setIcon(scaleImage(60, 60, icon));
				} else if (count == 50) {
					label_50.setIcon(scaleImage(60, 60, icon));
				} else if (count == 51) {
					label_51.setIcon(scaleImage(60, 60, icon));
				} else if (count == 52) {
					label_52.setIcon(scaleImage(60, 60, icon));
				} else if (count == 53) {
					label_53.setIcon(scaleImage(60, 60, icon));
				} else if (count == 54) {
					label_54.setIcon(scaleImage(60, 60, icon));
				} else if (count == 55) {
					label_55.setIcon(scaleImage(60, 60, icon));
				} else if (count == 56) {
					label_56.setIcon(scaleImage(60, 60, icon));
				} else if (count == 57) {
					label_57.setIcon(scaleImage(60, 60, icon));
				} else if (count == 58) {
					label_58.setIcon(scaleImage(60, 60, icon));
				} else if (count == 59) {
					label_59.setIcon(scaleImage(60, 60, icon));
				} else if (count == 60) {
					label_60.setIcon(scaleImage(60, 60, icon));
				} else if (count == 61) {
					label_61.setIcon(scaleImage(60, 60, icon));
				} else if (count == 62) {
					label_62.setIcon(scaleImage(60, 60, icon));
				} else if (count == 63) {
					label_63.setIcon(scaleImage(60, 60, icon));
				} else if (count == 64) {
					label_64.setIcon(scaleImage(60, 60, icon));
				} else if (count > 64) {
					System.out.printf("something has gone wrong");
				}
			}
		});
		btn_extract.setBounds(16, 169, 93, 23);
		panel_pre_menu.add(btn_extract);
		btn_extract.setText("\u63d0\u53d6");
		{
			JButton btn_select_origin = new JButton(
					"\u9009\u62E9\u539F\u59CB\u56FE\u7247");
			panel_pre_menu.add(btn_select_origin);
			btn_select_origin.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					JFileChooser fileChooser = new JFileChooser("");
					int returnVal = fileChooser.showOpenDialog(fileChooser);
					if (returnVal == JFileChooser.APPROVE_OPTION) {
						String f = fileChooser.getSelectedFile()
								.getAbsolutePath();
						ImageIcon icon = new ImageIcon(f, "");
						Label_origin.setIcon(icon);
					}
				}
			});
			btn_select_origin.setBounds(6, 76, 113, 23);
		}
		{
			JButton btn_saveimg = new JButton(
					"\u4FDD\u5B58\u622A\u53D6\u7684\u56FE\u7247");
			panel_pre_menu.add(btn_saveimg);
			btn_saveimg.setBounds(16, 347, 93, 22);
			btn_saveimg.setText("\u4fdd\u5b58\u56fe\u7247");
			btn_saveimg.addActionListener(new ActionListener() {
				// btnNewButton_6
				public void actionPerformed(ActionEvent e) {
					String f = null;
					JFileChooser saveFc = new JFileChooser();
					int returnVal = saveFc.showSaveDialog(saveFc);
					if (returnVal == JFileChooser.APPROVE_OPTION) {
						f = saveFc.getSelectedFile().getAbsolutePath();
					}

					c1 = panel_extract.getX()+10;
					c2 = panel_extract.getY()+30;
					int w = panel_extract.getWidth()-10;
					int h = panel_extract.getHeight()-10;
					Robot robot;
					try {
						robot = new Robot();
						IM = robot.createScreenCapture(new Rectangle(c1, c2, w,
								h));
					} catch (AWTException e2) {
						// TODO Auto-generated catch block
						e2.printStackTrace();
					}
					if (IM == null) {
						JOptionPane.showMessageDialog(null,
								"please extract the origin image first!");
						return;
					}
					File file = new File(f + "" + "." + "jpg");
					try {
						ImageIO.write(IM, "jpg", file);
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
			});
		}
	}
}
