import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
import seaborn as sns

# Load the DataFrame
dwi = pd.read_csv('hansen_dwi.csv')

# Set bandwidth and calculate rectangular kernel weights
bw = 0.05
dwi['wt'] = np.where(np.abs(dwi['bac1'] - 0.08) <= bw, 1, 0)

# Filter the data to include only rows where 'wt' > 0
filtered_data = dwi[dwi['wt'] > 0]

# Define the regression formula
formula = 'recidivism ~ dui + bac1 + dui:bac1 + male + white + aged + acc'

# Fit the robust linear model with cluster-robust standard errors, using filtered data and weights
model = smf.wls(formula=formula, data=filtered_data, weights=filtered_data['wt']).fit(cov_type='cluster', cov_kwds={'groups': filtered_data['dui']})

# Set the style of the plot
sns.set_style("whitegrid")

# Define the cutoff and bandwidth
cutoff = 0.08

# Define the plot range and filter data for plotting
plot_range = (0, 0.3)
dwi_plot = dwi[(dwi['bac1'] >= plot_range[0]) & (dwi['bac1'] <= plot_range[1])]

# Plotting
plt.figure(figsize=(10, 6))
# Plot the scatter plot of the data points within the specified range
sns.scatterplot(x='bac1', y='recidivism', data=dwi_plot, alpha=0.5, edgecolor=None)

# Generating values for 'bac1' within the plot range for the fitted line
bac1_vals = np.linspace(plot_range[0], plot_range[1], 500)

# Predictions for the plot
predictions = model.get_prediction(pd.DataFrame({
    'bac1': bac1_vals,
    'dui': [1 if x >= cutoff else 0 for x in bac1_vals],
    'male': [np.mean(dwi['male'])] * len(bac1_vals),
    'white': [np.mean(dwi['white'])] * len(bac1_vals),
    'aged': [np.mean(dwi['aged'])] * len(bac1_vals),
    'acc': [np.mean(dwi['acc'])] * len(bac1_vals)
})).summary_frame(alpha=0.05)

# Plot the fitted regression lines
plt.plot(bac1_vals, predictions['mean'], color='red', label='Fitted Line')

# Drawing the cutoff line
plt.axvline(x=cutoff, linestyle='--', color='black', label='Cutoff')

# Setting plot labels and legend
plt.xlabel('BAC1')
plt.ylabel('Recidivism')
plt.title('RDD Plot of Recidivism vs. BAC1')
plt.legend()
plt.xlim(plot_range)
plt.ylim(-0.1, 0.5)  # Adjust y-axis limits to improve visibility if necessary
plt.show()
