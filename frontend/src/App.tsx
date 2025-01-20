import React, { useState } from 'react';
import axios from 'axios';
import SearchBar from './components/SearchBar';
import WeatherCard from './components/WeatherCard';

axios.defaults.baseURL = 'http://localhost:4000';

const App: React.FC = () => {
  const [weather, setWeather] = useState<any | null>(null);
  const [error, setError] = useState('');

  const fetchWeather = async (city: string) => {
    setError('');
    try {
      const response = await axios.get(`/weather/${city}`);
      setWeather(response.data);
    } catch (err) {
      setWeather(null);
      setError('Failed to fetch weather data. Please try again.');
    }
  };

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-3xl font-bold mb-4 text-center">Weather Dashboard</h1>
      <SearchBar onSearch={fetchWeather} />
      {error && <p className="text-red-500 mt-4">{error}</p>}
      {weather && <WeatherCard weather={weather} />}
    </div>
  );
};

export default App;
